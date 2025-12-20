//
//  OutlookResponse.swift
//  RedzoneCore
//
//  Created by Greg Whatley on 9/20/25.
//

internal import Algorithms
import CoreLocation
import Foundation
import GeoJSON
import OSLog

public struct OutlookResponse: Sendable, Hashable {
    private static let logger: Logger = .create()

    public struct Feature: Sendable, Hashable, Identifiable {
        public let multiPolygon: GeoJSONMultiPolygon
        public let properties: Outlook.Properties

        init?(feature: GeoJSONFeature) {
            guard case let .multiPolygon(mp) = feature.geometry else { return nil }
            self.multiPolygon = mp
            self.properties = .init(from: feature)
        }

        public func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
            multiPolygon.contains(.init(coordinate: coordinate))
        }

        public var id: String {
            properties.id
        }
    }

    public let outlookType: OutlookType
    public let features: [Feature]

    init(data: Data, outlookType: OutlookType) throws {
        do {
            let object = try GeoJSONDecoder().decode(data, options: .swapLatitudeLongitude)
            self.features = object.features?.compactMap {
                Feature(feature: $0)
            } ?? []
            self.outlookType = outlookType
        } catch {
            Self.logger.fault("Failed to decode outlook data for '\(String(describing: outlookType))': \(error.localizedDescription)")
            throw error
        }
    }

    public func findOutlook(containing location: CLLocationCoordinate2D) -> Outlook? {
        let (riskFeatures, sigFeatures) = features.partitioned { feature in
            feature.properties.severity == .significant
        }
        guard let tappedRisk = riskFeatures.reversed().first(where: { $0.contains(location) }) else { return nil }
        let tappedSig = sigFeatures.first { $0.contains(location) }
        return .init(wrapping: tappedRisk, significantFeature: tappedSig, type: outlookType)
    }
}
