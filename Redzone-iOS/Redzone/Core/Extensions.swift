//
//  Extensions.swift
//  Redzone
//
//  Created by Greg Whatley on 5/26/25.
//


import CoreLocation
import GeoJSON
import MapKit
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

extension MapCameraPosition {
    static var unitedStates: MapCameraPosition {
        .region(.init(
            center: .init(latitude: 37.09024, longitude: -95.712891),
            span: .init(latitudeDelta: 60, longitudeDelta: 30)
        ))
    }
}

extension OutlookType {
    var title: LocalizedStringKey {
        "\(subSection) • Day \(day)"
    }
}

// TODO: Remove after Xcode 26 GA
#if compiler(<6.2)
extension LocalizedStringResource {
    static var disclaimerAffiliation: LocalizedStringResource { .init("disclaimerAffiliation") }
    static var disclaimerUse: LocalizedStringResource { .init("disclaimerUse") }
    static var disclaimerLiability: LocalizedStringResource { .init("disclaimerLiability") }
    static var disclaimerCopyright: LocalizedStringResource { .init("disclaimerCopyright") }
    static var disclaimerSafety: LocalizedStringResource { .init("disclaimerSafety") }
    static var disclaimerPrivacy: LocalizedStringResource { .init("disclaimerPrivacy") }
    static var disclaimerPrivacyExternal: LocalizedStringResource { .init("disclaimerPrivacyExternal") }
}
#endif
