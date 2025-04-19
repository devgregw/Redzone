//
//  OutlookCache.swift
//
//
//  Created by Greg Whatley on 4/6/24.
//

import Foundation
import Vapor

actor OutlookCache {
    static let shared: OutlookCache = OutlookCache()
    
    private struct Key: Hashable {
        let outlook: OutlookType
        let fingerprint: String?
        let timestamp: SPCTimestamp
    }
    
    private var cache: [Key: Data] = [:]
    
    private let logger: Logger = {
        var logger = Logger(label: "OutlookCache")
        #if DEBUG
        logger.logLevel = .trace
        #endif
        return logger
    }()
    
    func get(_ outlook: OutlookType, _ fingerprint: String?, _ timestamp: SPCTimestamp) -> Data? {
        let value = cache[.init(outlook: outlook, fingerprint: fingerprint, timestamp: timestamp)]
        if value != nil {
            logger.debug("Cache hit for GeoJSON: \(outlook.prefix) \(outlook.suffix) \(fingerprint ?? "-") \(timestamp.date)")
        }
        return value
    }
    
    func set(_ data: Data?, _ outlook: OutlookType, _ fingerprint: String?, _ timestamp: SPCTimestamp) {
        if let data {
            cleanup()
            logger.debug("Caching GeoJSON (\(data.count) bytes): \(outlook.prefix) \(outlook.suffix) \(fingerprint ?? "-") \(timestamp.date)")
        }
        cache[.init(outlook: outlook, fingerprint: fingerprint, timestamp: timestamp)] = data
    }
    
    private func cleanup() {
        cache.keys
            .filter { abs($0.timestamp.timeIntervalSinceNow) >= 60 * 60 * 24 * 2 }
            .forEach {
                logger.debug("Removing stale cache item: \($0.outlook.prefix) \($0.outlook.suffix) \($0.fingerprint ?? "-") \($0.timestamp.date)")
                cache[$0] = nil
            }
    }
}
