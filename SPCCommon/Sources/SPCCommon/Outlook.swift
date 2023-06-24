//
//  Outlook.swift
//  SPC
//
//  Created by Greg Whatley on 4/7/23.
//

import Foundation
import MapKit

public struct Outlook: Codable, Identifiable, Comparable, Hashable {
    public static func < (lhs: Outlook, rhs: Outlook) -> Bool {
        if lhs.type == .significant {
            return false
        } else if rhs.type == .significant {
            return true
        }
        if let lt = lhs.type, let rt = rhs.type {
            return lt < rt
        } else if let lv = Double(lhs.id), let rv = Double(rhs.id) {
            return lv > rv
        } else {
            return lhs.id < rhs.id
        }
    }
    
    public static func == (lhs: Outlook, rhs: Outlook) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(polygons.hashValue)
    }
    
    public typealias Polygon = [CLLocationCoordinate2D]
    
    public let polygons: [Polygon]
    public let id: String
    public let name: String
    public let colors: OutlookColor
    public let dates: OutlookDates
    
    public var isSignificant: Bool {
        type == .significant
    }
    
    public var type: OutlookSeverity? {
        .init(rawValue: id)
    }
}
