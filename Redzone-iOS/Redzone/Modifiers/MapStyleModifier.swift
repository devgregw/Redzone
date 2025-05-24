//
//  MapStyleModifier.swift
//  Redzone
//
//  Created by Greg Whatley on 2/8/24.
//

import MapKit
import SwiftUI

extension View {
    func mapStyle(_ style: MapViewStyle) -> some View {
        let poi: PointOfInterestCategories = .including([.airport, .hospital, .school, .stadium, .university])
        let newStyle: MapStyle
        switch style {
        case .standard: newStyle = .standard(pointsOfInterest: poi)
        case .hybrid: newStyle = .hybrid(pointsOfInterest: poi)
        case .satellite: newStyle = .imagery
        }
        return mapStyle(newStyle)
    }
}
