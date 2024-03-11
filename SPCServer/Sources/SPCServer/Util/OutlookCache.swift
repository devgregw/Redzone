//
//  OutlookCache.swift
//
//
//  Created by Greg Whatley on 6/29/23.
//

import Foundation
import Vapor

actor OutlookCache {
    private struct CacheContent: Codable {
        struct Feature: Codable {
            struct Properties: Codable {
                enum CodingKeys: String, CodingKey {
                    case expire = "EXPIRE"
                }
                
                let expire: String
            }
            
            let properties: Properties
        }
        
        let features: [Feature]
    }
    
    static let shared = OutlookCache()
    
    private init() { }
    
    private var cache: [OutlookType: (Data, Date)] = [:]
    
    private func parseDate(string: String?) -> Date? {
        guard let string else { return nil }
        let year = Int(string.substring(0..<4))
        let month = Int(string.substring(4..<6))
        let day = Int(string.substring(6..<8))
        let hour = Int(string.substring(8..<10))
        let minute = Int(string.substring(10..<12))
        let components = DateComponents(calendar: .current, timeZone: .init(identifier: "UTC"), year: year, month: month, day: day, hour: hour, minute: minute, second: 0)
        return components.date
    }
    
    func data(for outlook: OutlookType) -> Data? {
        guard let (data, expiration) = cache[outlook],
              expiration > .now else {
            return nil
        }
        
        return data
    }
    
    func set(data: Data, for outlook: OutlookType) {
        guard let geoJSON = try? JSONDecoder().decode(CacheContent.self, from: data),
              let expirationDate = parseDate(string: geoJSON.features.first?.properties.expire) else {
            cache.removeValue(forKey: outlook)
            return
        }
        
        cache[outlook] = (data, expirationDate)
    }
}
