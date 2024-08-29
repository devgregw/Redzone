//
//  GeoJSONFeature.swift
//  SPCMap
//
//  Created by Greg Whatley on 8/25/24.
//

import CoreLocation
import GeoJSON

extension GeoJSONFeature: Identifiable, Comparable {
    public var id: Int { hashValue }
    
    public static func < (lhs: GeoJSONFeature, rhs: GeoJSONFeature) -> Bool {
        if lhs.outlookProperties.isSignificant {
            false
        } else if rhs.outlookProperties.isSignificant {
            true
        } else {
            lhs.outlookProperties.severity < rhs.outlookProperties.severity
        }
    }
    
    var outlookProperties: OutlookProperties {
        .init(
            id: properties["LABEL"] ?? "",
            title: properties["LABEL2"] ?? "",
            fillColor: properties["fill"] ?? "",
            strokeColor: properties["stroke"] ?? "",
            expire: properties["EXPIRE"] ?? "",
            valid: properties["VALID"] ?? "",
            issue: properties["ISSUE"] ?? ""
        )
    }
    
    var multiPolygon: [GeoJSONPolygon]? {
        guard case let .multiPolygon(multiPolygon) = geometry else {
            return nil
        }
        return multiPolygon
    }
}

extension Sequence where Element == GeoJSONFeature {
    func first(at location: CLLocationCoordinate2D) -> GeoJSONFeature? {
        first {
            $0.multiPolygon?.contains(point: location) ?? false
        }
    }
}
