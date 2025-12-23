//
//  MapKit.swift
//  RedzoneUI
//
//  Created by Greg Whatley on 9/21/25.
//

import Foundation
import GeoJSON
import MapKit
import RedzoneCore
import SwiftUI

public extension MapCameraPosition {
    static var unitedStates: MapCameraPosition {
        .region(.init(
            center: .init(latitude: 37.09024, longitude: -95.712891),
            span: .init(latitudeDelta: 60, longitudeDelta: 30)
        ))
    }
}

extension MapPolygon {
    init(_ polygon: GeoJSONPolygon) {
        self.init(MKPolygon(
            coordinates: polygon.exterior.positions.map(\.clLocationCoordinate),
            count: polygon.exterior.positions.count,
            interiorPolygons: polygon.holes.map {
                MKPolygon(coordinates: $0.positions.map(\.clLocationCoordinate), count: $0.positions.count)
            }
        ))
    }
}
