//
//  MapMultiPolygon.swift
//  SPCMap
//
//  Created by Greg Whatley on 2/11/24.
//

import MapKit
import SwiftUI

struct MapMultiPolygon: MapContent {
    let multiPolygon: OutlookMultiPolygon
    
    var body: some MapContent {
        ForEach(multiPolygon.polygons.reversed(), id: \.hashValue) {
            MapPolygon(points: $0.points)
                .foregroundStyle(multiPolygon.fillColor)
                .stroke(multiPolygon.strokeColor, style: .init(dash: multiPolygon.dashed ? [5, 5] : []))
                .mapOverlayLevel(level: .aboveRoads)
        }
    }
}
