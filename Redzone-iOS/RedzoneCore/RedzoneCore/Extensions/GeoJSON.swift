//
//  GeoJSON.swift
//  RedzoneCore
//
//  Created by Greg Whatley on 9/20/25.
//

import CoreLocation
import Foundation
import GeoJSON

public extension GeoJSONPosition {
    init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }

    var clLocationCoordinate: CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }
}

public typealias GeoJSONMultiPolygon = [GeoJSONPolygon]
