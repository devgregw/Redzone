//
//  StatusSection.swift
//  Redzone
//
//  Created by Greg Whatley on 9/30/25.
//

import SwiftUI
import RedzoneCore
import RedzoneUI

struct StatusSection: View {
    @Environment(LocationService.self) private var locationService

    let response: Result<OutlookResponse, any Error>?

    var body: some View {
        Section {
            VStack(spacing: 16) {
                Group {
                    switch response {
                    case .success where locationService.lastKnownLocation != nil:
                        Image(systemName: "cloud.sun.fill")
                            .font(.largeTitle)
                            .symbolRenderingMode(.multicolor)

                        Text(.noRisk)
                            .font(.title.weight(.medium))
                            .multilineTextAlignment(.center)

                    case .success where locationService.lastKnownLocation == nil:
                        Image(systemName: "location.slash.fill")
                            .font(.largeTitle)
                            .symbolRenderingMode(.hierarchical)

                        Text(.locationDisabled)
                            .font(.title.weight(.medium))
                            .multilineTextAlignment(.center)

                    case .failure:
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .symbolRenderingMode(.multicolor)

                        Text(.failedToLoadOutlookData)
                            .font(.title.weight(.medium))
                            .multilineTextAlignment(.center)

                    default:
                        ProgressView()
                            .progressViewStyle(.circular)

                        Text(.loading)
                            .font(.title.weight(.medium))
                            .multilineTextAlignment(.center)
                    }
                }
                .opacity(0.65)

                if case .success = response,
                   locationService.lastKnownLocation == nil,
                   let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    Link(destination: settingsURL) {
                        Label("Open Settings", systemImage: "gear")
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
        .geometryGroup()
    }
}
