//
//  MapStyleModifier.swift
//  RedzoneUI
//
//  Created by Greg Whatley on 9/21/25.
//

import MapKit
import SwiftUI

public extension View {
    func mapStyle(
        _ style: MapViewStyle,
        pointsOfInterest: PointOfInterestCategories = .including(.airport, .hospital, .school, .stadium, .university)
    ) -> some View {
        mapStyle({
            switch style {
            case .standard: .standard(pointsOfInterest: pointsOfInterest)
            case .hybrid: .hybrid(pointsOfInterest: pointsOfInterest)
            }
        }())
    }
}
