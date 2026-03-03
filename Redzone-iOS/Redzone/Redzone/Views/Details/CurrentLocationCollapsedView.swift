//
//  CurrentLocationCollapsedView.swift
//  Redzone
//
//  Created by Greg Whatley on 9/30/25.
//

import RedzoneCore
import RedzoneUI
import SwiftUI

struct CurrentLocationCollapsedView: View {
    @Environment(LocationService.self) private var locationService
    
    let response: Result<OutlookCollection, any Error>?
    let outlookType: OutlookType
    let currentLocationOutlook: ResolvedOutlook?

    private var noRiskImage: String {
        switch outlookType {
        case .convective:
            "cloud.sun.fill"
        case .fire:
            "leaf.fill"
        @unknown default:
            "sparkles"
        }
    }

    @ViewBuilder private func currentLocationLabel(outlook: ResolvedOutlook) -> some View {
        switch outlookType {
        case let .convective(subtype):
            if let primary = outlook[.convectivePrimary] {
                Label {
                    Text(primary.properties.title)
                        .fontWeight(.medium)
                } icon: {
                    HStack {
                        if let cigRisk = outlook[.convectiveCIG]?.properties.severity {
                            let imageName = switch cigRisk {
                            case .cig2: "exclamationmark.2"
                            case .cig3: "exclamationmark.3"
                            default: "exclamationmark"
                            }
                            Image(systemName: imageName)
                                .foregroundStyle(.red)
                                .symbolRenderingMode(.monochrome)
                        }
                        OutlookLegendIconView(properties: primary.properties)
                    }
                }
            }
        case .fire:
            if let windRh = outlook[.fireWindRH] {
                Label {
                    Text(windRh.properties.title)
                        .fontWeight(.medium)
                } icon: {
                    OutlookLegendIconView(properties: windRh.properties)
                }
            }
        @unknown default:
            EmptyView()
        }
    }

    var body: some View {
        HStack {
            switch response {
            case .success(let success):
                if let currentLocationOutlook {
                    currentLocationLabel(outlook: currentLocationOutlook)
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
                    Label(.noRisk, systemImage: noRiskImage)
                        .fontWeight(.medium)
                        .symbolRenderingMode(.multicolor)
                    Spacer()
                    Image(systemName: "location.circle.fill")
                        .symbolRenderingMode(.multicolor)
                        .symbolEffect(.pulse.byLayer, options: .repeat(.continuous))
                }
            case .failure:
                Label(.failedToLoadOutlookData, systemImage: "xmark.circle.fill")
                    .symbolRenderingMode(.multicolor)
                Spacer()
            case nil:
                Label {
                    Text(.loading)
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                } icon: {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                Spacer()
            }
        }
        .padding()
    }
}
