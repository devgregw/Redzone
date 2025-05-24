//
//  Extensions.swift
//  Redzone
//
//  Created by Greg Whatley on 4/6/24.
//

import CoreLocation
import GeoJSON

extension Collection where Element == GeoJSONFeature {
    func findTappedOutlook(at coordinate: CLLocationCoordinate2D) -> TappedOutlook? {
        let (significantFeatures, otherFeatures) = split(on: \.outlookProperties.isSignificant)
        guard let tappedFeature = otherFeatures.reversed().first(where: {
            $0.multiPolygon?.contains(point: coordinate) ?? false
        }) else {
            return nil
        }
        
        let isSignificant = significantFeatures.compactMap { $0.multiPolygon }.flattened().contains(point: coordinate)
        
        return .init(highestRisk: tappedFeature, isSignificant: isSignificant)
    }
}
