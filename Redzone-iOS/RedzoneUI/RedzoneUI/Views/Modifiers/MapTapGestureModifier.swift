//
//  MapTapGestureModifier.swift
//  RedzoneUI
//
//  Created by Greg Whatley on 9/21/25.
//

import CoreLocation
import GeoJSON
import MapKit
import OSLog
import RedzoneCore
import SwiftUI

struct MapTapGestureModifier: ViewModifier {
    private static let logger: Logger = .create()
    let operation: (CLLocationCoordinate2D) -> Void

    func body(content: Content) -> some View {
        MapReader { proxy in
            content
                .highPriorityGesture(
                    SpatialTapGesture(coordinateSpace: .global)
                        .onEnded {
                            if let coordinate = proxy.convert($0.location, from: .global) {
                                // swiftlint:disable:next line_length
                                Self.logger.debug("Tap @ (\($0.location.x), \($0.location.y)) mapped to coordinate (\(coordinate.latitude), \(coordinate.longitude)).")
                                operation(coordinate)
                            }
                        }
                )
        }
    }

}

public extension View {
    func mapTapGesture(perform operation: @escaping (CLLocationCoordinate2D) -> Void) -> some View {
        modifier(MapTapGestureModifier(operation: operation))
    }
}

#Preview {
    let multiPolygon = [
        GeoJSONPolygon(exterior: [
            // Coordinate points for a square around the state of Texas
            .init(latitude: 25.83333, longitude: -93.516667),
            .init(latitude: 25.83333, longitude: -106.55),
            .init(latitude: 36.5, longitude: -106.55),
            .init(latitude: 36.5, longitude: -93.516667),
            .init(latitude: 25.83333, longitude: -93.516667)
        ], holes: [
            .init([
                .init(latitude: 33.25, longitude: -97.5),
                .init(latitude: 33.25, longitude: -96.4),
                .init(latitude: 32.5, longitude: -96.4),
                .init(latitude: 32.5, longitude: -97.5),
                .init(latitude: 33.25, longitude: -97.5)
            ])
        ])
    ]
    Map(initialPosition: .unitedStates) {
        OutlookPolygon(
            multiPolygon,
            properties: Outlook.Properties(id: "", title: "", fillColor: "#0000FF", strokeColor: "#FF0000", expire: "", valid: "", issue: "")
        )
    }
    .mapTapGesture {
        if multiPolygon.contains(.init(coordinate: $0)) {
            print("Tapped inside multi polygon")
        } else {
            print("Tapped outside multi polygon")
        }
    }
}
