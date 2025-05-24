//
//  MapMultiPolygon.swift
//  Redzone
//
//  Created by Greg Whatley on 2/11/24.
//

import MapKit
import SwiftUI
import GeoJSON

struct MapMultiPolygon: MapContent {
    let multiPolygon: [GeoJSONPolygon]
    let properties: OutlookProperties
    
    var body: some MapContent {
        ForEach(multiPolygon.reversed(), id: \.hashValue) {
            MapPolygon(points: $0.exterior.map { .init(.init(latitude: $0.latitude, longitude: $0.longitude)) })
                .foregroundStyle(properties.fillColor.opacity(0.25))
                .stroke(properties.strokeColor, style: .init(dash: properties.isSignificant ? [5, 5] : []))
                .mapOverlayLevel(level: .aboveRoads)
        }
    }
}
