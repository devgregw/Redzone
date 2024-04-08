//
//  OutlookDownloader.swift
//
//
//  Created by Greg Whatley on 4/6/24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Vapor

class OutlookDownloader {    
    private static let logger: Logger = {
        var logger = Logger(label: "OutlookDownloader")
        #if DEBUG
        logger.logLevel = .trace
        #endif
        return logger
    }()
    
    private static func getData(url: URL) async throws -> Data? {
        logger.info("Fetching GeoJSON: \(url.absoluteString)")
        let (data, response) = try await URLSessionAdapter.shared.data(from: url)
        return if let response = response as? HTTPURLResponse,
                  response.statusCode == 200 {
            data
        } else {
            nil
        }
    }
    
    private static func fetchOutlook(_ outlook: OutlookType, timestamp: SPCTimestamp, fingerprint: String?) async throws -> Data? {
        guard let url = URL(string: "https://www.spc.noaa.gov/products/\(outlook != .convective3(probabilistic: true) && outlook.subSection == "Probabilistic" ? "exper/day4-8" : "outlook")/archive/\(timestamp.year)/\(outlook.prefix)_\(timestamp.date)\(fingerprint ?? "").\(outlook.extension)") else {
            throw Abort(.internalServerError, reason: "Unable to parse outlook data URL.")
        }
        if let cached = await OutlookCache.shared[outlook, fingerprint, timestamp] {
            return cached
        } else if let data = try await getData(url: url) {
            await MainActor.run {
                OutlookCache.shared[outlook, fingerprint, timestamp] = data
            }
            return data
        } else {
            return nil
        }
    }
    
    static func fetchOutlook(_ outlook: OutlookType) async throws -> Data {
        if let issuances = outlook.issuances {
            let timestamp: SPCTimestamp
            let issuance: Int
            if let latestIssuance: Int = issuances.first(where: {
                // 1200 is actually issued at 600
                let value = if $0 == 1200 { 600 } else { $0 }
                return SPCTimestamp.now.time >= value
            }) {
                issuance = latestIssuance
                timestamp = .now
            } else if let firstIssuance: Int = issuances.first {
                issuance = firstIssuance
                timestamp = .yesterday
            } else {
                throw Abort(.internalServerError, reason: "Outlook type configuration failure.")
            }
            return if let data = try await fetchOutlook(outlook, timestamp: timestamp, fingerprint: "_\(issuance.stringByPaddingZeroes(length: 4))_\(outlook.suffix)") {
                data
            } else if timestamp != .yesterday,
                      let firstIssuance: Int = issuances.first,
                      let data = try await fetchOutlook(outlook, timestamp: .yesterday, fingerprint: "_\(firstIssuance.stringByPaddingZeroes(length: 4))_\(outlook.suffix)") {
                data
            } else {
                throw Abort(.notFound, reason: "SPC outlook file not found.")
            }
        } else {
            return if let data = try await fetchOutlook(outlook, timestamp: .now, fingerprint: nil) {
                data
            } else if let data = try await fetchOutlook(outlook, timestamp: .yesterday, fingerprint: nil) {
                data
            } else {
                throw Abort(.notFound, reason: "SPC outlook file not found.")
            }
        }
    }
}
