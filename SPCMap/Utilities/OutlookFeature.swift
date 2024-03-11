//
//  OutlookFeature.swift
//  SPCMap
//
//  Created by Greg Whatley on 6/25/23.
//

import MapKit

class OutlookFeature: MKGeoJSONFeature, Comparable, Identifiable {
    lazy var outlookProperties: OutlookProperties = {
        guard let properties,
              let decoded = try? JSONDecoder().decode(OutlookProperties.self, from: properties) else {
            return .init(id: "", title: "", fillColor: "", strokeColor: "", expire: "", valid: "", issue: "")
        }
        return decoded
    }()
    
    private let underlyingFeature: MKGeoJSONFeature
    
    override var properties: Data? { underlyingFeature.properties }
    override var identifier: String? { underlyingFeature.identifier }
    override var geometry: [MKShape & MKGeoJSONObject] {
        multiPolygons
    }
    
    var multiPolygons: [OutlookMultiPolygon] {
        underlyingFeature.geometry
            .compactMap { $0 as? MKMultiPolygon }
            .map { OutlookMultiPolygon(from: $0, properties: outlookProperties) }
    }
    
    init(from feature: MKGeoJSONFeature) {
        underlyingFeature = feature
        super.init()
    }
    
    static func < (lhs: OutlookFeature, rhs: OutlookFeature) -> Bool {
        if lhs.outlookProperties.isSignificant {
            false
        } else if rhs.outlookProperties.isSignificant {
            true
        } else {
            lhs.outlookProperties.severity < rhs.outlookProperties.severity
        }
    }
    
    var id: Int {
        hashValue
    }
}
