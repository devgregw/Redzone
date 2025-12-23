//
//  OutlookPolygon.swift
//  RedzoneUI
//
//  Created by Greg Whatley on 9/21/25.
//

import GeoJSON
import MapKit
import RedzoneCore
import SwiftUI

public struct OutlookPolygon: MapContent {
    let multiPolygon: GeoJSONMultiPolygon
    let properties: Outlook.Properties

    public init(_ multiPolygon: GeoJSONMultiPolygon, properties: Outlook.Properties) {
        self.multiPolygon = multiPolygon
        self.properties = properties
    }

    public init(feature: OutlookResponse.Feature) {
        self.multiPolygon = feature.multiPolygon
        self.properties = feature.properties
    }

    public var body: some MapContent {
        MapMultiPolygon(multiPolygon)
            .foregroundStyle(Color(hex: properties.fillColor).opacity(0.25))
            .stroke(Color(hex: properties.strokeColor), style: .init(dash: properties.severity == .significant ? [5, 5] : []))
            .mapOverlayLevel(level: .aboveRoads)
    }
}

#Preview {
    Map(initialPosition: .unitedStates) {
        OutlookPolygon(
            [
                .init(exterior: [
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
            ],
            properties: Outlook.Properties(id: "", title: "", fillColor: "#0000FF", strokeColor: "#FF0000", expire: "", valid: "", issue: "")
        )
    }
}
