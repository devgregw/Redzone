//
//  Extensions.swift
//  Redzone
//
//  Created by Greg Whatley on 5/26/25.
//


import CoreLocation
import GeoJSON
import SwiftUI

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

extension Bundle {
    var versionString: String {
        guard let shortVersion = infoDictionary?["CFBundleShortVersionString"] as? String,
              let buildVersion = infoDictionary?["CFBundleVersion"] as? String else {
            return "--"
        }
        
        return "\(shortVersion) (\(buildVersion))"
    }
}
