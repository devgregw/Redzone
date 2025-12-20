//
//  MapMultiPolygon.swift
//  RedzoneUI
//
//  Created by Greg Whatley on 9/21/25.
//

import GeoJSON
import MapKit
import RedzoneCore
import SwiftUI

public struct MapMultiPolygon: MapContent {
    let multiPolygon: GeoJSONMultiPolygon

    public init(_ multiPolygon: GeoJSONMultiPolygon) {
        self.multiPolygon = multiPolygon
    }

    public var body: some MapContent {
        ForEach(multiPolygon.reversed(), id: \.hashValue) {
            MapPolygon($0)
        }
    }
}

#Preview {
    Map(initialPosition: .unitedStates) {
        MapMultiPolygon([
            .init(exterior: [
                // Coordinate points for a square around the state of Texas
                .init(latitude: 25.83333, longitude: -93.516667),
                .init(latitude: 25.83333, longitude: -106.55),
                .init(latitude: 36.5, longitude: -106.55),
                .init(latitude: 36.5, longitude: -93.516667),
                .init(latitude: 25.83333, longitude: -93.516667),
            ], holes: [
                // Hole covering the DFW Metroplex
                .init([
                    .init(latitude: 33.25, longitude: -97.5),
                    .init(latitude: 33.25, longitude: -96.4),
                    .init(latitude: 32.5, longitude: -96.4),
                    .init(latitude: 32.5, longitude: -97.5),
                    .init(latitude: 33.25, longitude: -97.5)
                ])
            ])
        ])
    }
}
