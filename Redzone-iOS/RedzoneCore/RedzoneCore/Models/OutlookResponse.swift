//
//  OutlookCollection.swift
//  RedzoneCore
//
//  Created by Greg Whatley on 9/20/25.
//

internal import Algorithms
import CoreLocation
import Foundation
import GeoJSON
import OSLog

public struct OutlookFeature: Sendable, Hashable, Identifiable {
    public let multiPolygon: GeoJSONMultiPolygon
    public let properties: OutlookProperties

    init?(feature: GeoJSONFeature) {
        guard case let .multiPolygon(multiPolygon) = feature.geometry else { return nil }
        self.multiPolygon = multiPolygon
        self.properties = .init(from: feature)
    }

    public func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
        multiPolygon.contains(.init(coordinate: coordinate))
    }

    public var id: String {
        properties.id
    }
}
