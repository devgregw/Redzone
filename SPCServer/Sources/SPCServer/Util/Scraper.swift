//
//  Scraper.swift
//  
//
//  Created by Greg Whatley on 5/9/23.
//

import Foundation
import SwiftSoup
import Vapor

struct Scraper {
    private static let logger: Logger = .init(label: "Scraper")
    private static let anchorSelector = "tr > td > a"
    
    static func scrapeGeoJSONURL(outlook: OutlookType) async throws -> URL {
        Self.logger.info("Scraping URL: \(outlook.collectionURL)")
        let data = try await URLSessionAdapter.shared.data(from: outlook.collectionURL).0
        guard let html = String(data: data, encoding: .utf8) else {
            throw Abort(.internalServerError, reason: "Failed to convert data to UTF-8 encoded string.")
        }
        
        let document = try SwiftSoup.parse(html)
        let anchors = try document.select(anchorSelector).filter {
            let text = $0.ownText()
            return text.hasPrefix(outlook.prefix) && text.hasSuffix("\(outlook.suffix).\(outlook.extension)") && !text.contains("sig")
        }
        
        guard let geoJSONUrl = try anchors.compactMap({ try $0.attr("href") }).last?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            throw Abort(.noContent, reason: "Outlook forecast not found.")
        }
        
        guard let url = URL(string: geoJSONUrl, relativeTo: outlook.collectionURL) else {
            throw Abort(.internalServerError, reason: "Detected malformed URL.")
        }
        
        return url
    }
}
