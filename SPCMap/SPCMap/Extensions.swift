//
//  Extensions.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/6/24.
//

import CoreLocation
import GeoJSON

extension Collection where Element == GeoJSONFeature {
    func findTappedOutlook(at coordinate: CLLocationCoordinate2D) -> TappedOutlook? {
        let (significantFeatures, otherFeatures) = splitFilter(by: \.outlookProperties.isSignificant)
        guard let tappedFeature = otherFeatures.first(where: {
            guard let multiPolygon = $0.multiPolygon else { return false }
            return multiPolygon.reversed().contains(point: coordinate)
        }) else {
            return nil
        }
        
        let isSignificant = significantFeatures.compactMap { $0.multiPolygon }.flattened().contains(point: coordinate)
        
        return .init(highestRisk: tappedFeature, isSignificant: isSignificant)
    }
}

extension URL: Identifiable {
    public var id: Int { hashValue }
}
