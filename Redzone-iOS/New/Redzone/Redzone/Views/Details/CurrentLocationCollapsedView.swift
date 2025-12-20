//
//  CurrentLocationCollapsedView.swift
//  Redzone
//
//  Created by Greg Whatley on 9/30/25.
//

import SwiftUI
import RedzoneCore
import RedzoneUI

struct CurrentLocationCollapsedView: View {
    @Environment(LocationService.self) private var locationService
    
    let response: Result<OutlookResponse, any Error>?
    let currentLocationOutlook: Outlook?

    var body: some View {
        HStack {
            if response == nil {
                Label {
                    Text(.loading)
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                } icon: {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                Spacer()
            } else if response?.error != nil {
                Label(.failedToLoadOutlookData, systemImage: "xmark.circle.fill")
                    .symbolRenderingMode(.multicolor)
                Spacer()
            } else if let currentLocationOutlook {
                Label {
                    Text(currentLocationOutlook.highestRisk.properties.title)
                        .fontWeight(.medium)
                } icon: {
                    HStack {
                        if currentLocationOutlook.significantFeature != nil {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .symbolRenderingMode(.multicolor)
                        }
                        OutlookLegendIconView(properties: currentLocationOutlook.highestRisk.properties)
                    }
                }
                Spacer()
                Image(systemName: "location.circle.fill")
                    .symbolRenderingMode(.multicolor)
                    .symbolEffect(.pulse.byLayer, options: .repeat(.continuous))
            } else if locationService.lastKnownLocation == nil {
                Text(.locationDisabled)
                    .foregroundStyle(Color(uiColor: .secondaryLabel))
                Spacer()
                Image(systemName: "location.slash.circle.fill")
                    .symbolRenderingMode(.hierarchical)
            } else {
                Label(.noRisk, systemImage: "cloud.sun.fill")
                    .fontWeight(.medium)
                    .symbolRenderingMode(.multicolor)
                Spacer()
                Image(systemName: "location.circle.fill")
                    .symbolRenderingMode(.multicolor)
                    .symbolEffect(.pulse.byLayer, options: .repeat(.continuous))
            }
        }
        .padding()
    }
}
