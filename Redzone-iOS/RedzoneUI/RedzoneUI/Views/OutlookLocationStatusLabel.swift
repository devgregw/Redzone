//
//  OutlookLocationStatusLabel.swift
//  RedzoneUI
//
//  Created by Greg Whatley on 9/28/25.
//

import CoreLocation
import RedzoneCore
import SwiftUI

public struct OutlookLocationStatusLabel: View {
    private let feature: OutlookResponse.Feature
    private let location: CLLocationCoordinate2D?
    private let response: OutlookResponse?

    public init(feature: OutlookResponse.Feature, location: CLLocationCoordinate2D?, response: OutlookResponse? = nil) {
        self.feature = feature
        self.location = location
        self.response = response
    }

    private func isAtCurrentLocation(_ location: CLLocationCoordinate2D) -> Bool {
        guard feature.contains(location) else { return false }
        guard let response else { return true }
        return response.findOutlook(containing: location)?.highestRisk == feature
    }

    public var body: some View {
        if let location {
            if isAtCurrentLocation(location) {
                Label(.forecastForYourLocation, systemImage: "location.circle.fill")
                    .foregroundStyle(.primary)
                    .fontWeight(.medium)
                    .symbolRenderingMode(.multicolor)
                    .symbolEffect(.pulse.byLayer, options: .repeat(.continuous))
            } else {
                Label(.excludesYourLocation, systemImage: "location.circle.fill")
                    .foregroundStyle(.secondary)
                    .symbolRenderingMode(.hierarchical)
            }
        } else {
            Label(.locationServicesDisabled, systemImage: "location.slash.circle.fill")
                .foregroundStyle(.secondary)
                .symbolRenderingMode(.hierarchical)
        }
    }
}
