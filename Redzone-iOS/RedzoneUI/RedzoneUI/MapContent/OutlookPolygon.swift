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
    let properties: OutlookProperties

    public init(_ multiPolygon: GeoJSONMultiPolygon, properties: OutlookProperties) {
        self.multiPolygon = multiPolygon
        self.properties = properties
    }

    public init(feature: OutlookFeature) {
        self.multiPolygon = feature.multiPolygon
        self.properties = feature.properties
    }

    public var body: some MapContent {
        MapMultiPolygon(multiPolygon)
            .outlookStyle(from: properties)
            .mapOverlayLevel(level: .aboveRoads)
    }
}

private extension MapContent {
    func outlookStyle(from properties: OutlookProperties) -> some MapContent {
        switch properties.severity {
        case .significant, .sigprobabilistic:
            self
                .foregroundStyle(Color(hex: properties.fillColor).opacity(0.25))
                .stroke(Color(hex: properties.strokeColor), style: .init(dash: [5, 5]))
        case .cig1:
            self
                .foregroundStyle(.clear)
                .stroke(Color(hex: properties.strokeColor), style: .init(dash: [2, 2]))
        case .cig2:
            self
                .foregroundStyle(.clear)
                .stroke(Color(hex: properties.strokeColor), style: .init(dash: [4, 2]))
        case .cig3:
            self
                .foregroundStyle(.clear)
                .stroke(Color(hex: properties.strokeColor), style: .init(dash: [6, 2]))
        default:
            self
                .foregroundStyle(Color(hex: properties.fillColor).opacity(0.25))
                .stroke(Color(hex: properties.strokeColor), style: .init())
        }
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
            properties: OutlookProperties(id: "", title: "", fillColor: "#0000FF", strokeColor: "#FF0000", expire: "", valid: "", issue: "")
        )
    }
}
