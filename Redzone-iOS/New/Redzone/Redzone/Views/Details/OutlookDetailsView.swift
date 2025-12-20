//
//  OutlookDetailsView.swift
//  Redzone
//
//  Created by Greg Whatley on 9/27/25.
//

import CoreLocation
import SwiftUI
import RedzoneCore
import RedzoneUI

struct OutlookDetailsView: View {
    @Environment(LocationService.self) private var locationService

    let response: Result<OutlookResponse, any Error>?
    let selectedOutlook: Outlook?
    let isFromSheet: Bool

    @ViewBuilder private func details(for outlook: Outlook, response: OutlookResponse) -> some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                switch outlook.highestRisk.properties.severity {
                case .generalThunder:
                    Text(.Convective.tstmHeadline)
                        .fontWeight(.medium)
                    Text(.Convective.tstmCaption)
                case .marginal:
                    Text(.Convective.mrglHeadline)
                        .fontWeight(.medium)
                    Text(.Convective.mrglCaption)
                case .slight:
                    Text(.Convective.slgtHeadline)
                        .fontWeight(.medium)
                    Text(.Convective.slgtCaption)
                case .enhanced:
                    Text(.Convective.enhHeadline)
                        .fontWeight(.medium)
                    Text(.Convective.enhCaption)
                case .moderate:
                    Text(.Convective.mdtHeadline)
                        .fontWeight(.medium)
                    Text(.Convective.mdtCaption)
                case .high:
                    Text(.Convective.highHeadline)
                        .fontWeight(.medium)
                    Text(.Convective.highCaption)
                case let .percentage(pct):
                    let label: LocalizedStringResource = {
                        switch outlook.outlookType {
                        case .convective(.day1(.wind)), .convective(.day2(.wind)): .Education.severeTstormWind
                        case .convective(.day1(.hail)), .convective(.day2(.hail)): .Education.severeTstormHail
                        case .convective(.day1(.tornado)), .convective(.day2(.tornado)): .Education.severeTstormTornado
                        default: .Convective.anySevereWeatherLabel
                        }
                    }()
                    Text(.Convective.percentageCaption(percentage: Int(pct * 100), label: String(localized: label)))
                default:
                    EmptyView()
                }
            }
            OutlookLocationStatusLabel(feature: outlook.highestRisk, location: locationService.lastKnownLocation?.coordinate, response: response)
        } header: {
            Label {
                Text(outlook.highestRisk.properties.title)
                    .font(.body.weight(.medium))
                    .foregroundStyle(Color(uiColor: .label))
            } icon: {
                switch outlook.outlookType {
                case .convective(let convective) where convective.isCategorical:
                    CategoricalGaugeView(properties: outlook.highestRisk.properties, mode: .legend)
                default:
                    OutlookLegendIconView(properties: outlook.highestRisk.properties)
                }
            }
            .labelStyle(.verticallyCentered)
        }
        .listRowBackground(Color(uiColor: .secondarySystemFill).opacity(0.8))

        if let sigSev = outlook.significantFeature {
            Section {
                switch outlook.outlookType {
                case .convective(.day1(.wind)), .convective(.day2(.wind)):
                    Text(.Convective.percentageCaption(percentage: 10, label: String(localized: .Education.sigSevTstormWind)))
                case .convective(.day1(.hail)), .convective(.day2(.hail)):
                    Text(.Convective.percentageCaption(percentage: 10, label: String(localized: .Education.sigSevTstormHail)))
                case .convective(.day1(.tornado)), .convective(.day2(.tornado)):
                    Text(.Convective.percentageCaption(percentage: 10, label: String(localized: .Education.sigSevTstormTornado)))
                default:
                    Text(.Convective.percentageCaption(percentage: 10, label: String(localized: .Convective.anySigSevWeatherLabel)))
                }
                OutlookLocationStatusLabel(feature: sigSev, location: locationService.lastKnownLocation?.coordinate)
            } header: {
                Label {
                    Text(sigSev.properties.title)
                        .font(.body.weight(.medium))
                        .foregroundStyle(Color(uiColor: .label))
                } icon: {
                    SigSevLegendIconView()
                }
            }
            .listRowBackground(Color(uiColor: .secondarySystemFill).opacity(0.8))
        }
    }

    var body: some View {
        List {
            if case let .success(response) = response,
               let selectedOutlook {
                details(for: selectedOutlook, response: response)
            } else {
                Section {
                    VStack(spacing: 16) {
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
                            EmptyView()
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .opacity(0.65)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }

            Section {
                NavigationLink {
                    List {
                        Section {
                            VStack(alignment: .leading, spacing: 16) {
                                Text(.Education.severeTstormHeader)
                                Label(.Education.severeTstormWind, systemImage: "wind")
                                Label(.Education.severeTstormHail, systemImage: "cloud.hail")
                                Label(.Education.severeTstormTornado, systemImage: "tornado")
                            }
                            VStack(alignment: .leading, spacing: 16) {
                                Text(.Education.sigSevTstormHeader)
                                Label(.Education.sigSevTstormWind, systemImage: "wind")
                                Label(.Education.sigSevTstormHail, systemImage: "cloud.hail")
                                Label(.Education.sigSevTstormTornado, systemImage: "tornado")
                            }
                        } footer: {
                            Text(.Education.severeTstormFootnote)
                        }
                        .listRowBackground(Color(uiColor: .secondarySystemFill).opacity(0.8))
                    }
                    .navigationTitle(.Education.severeTstormTitle)
                    .scrollContentBackground(.hidden)
                } label: {
                    Label(.Education.severeTstormLink, systemImage: "questionmark.circle")
                }

                if let commentaryURL = response?.value?.outlookType.commentaryURL {
                    ExternalLink(commentaryURL, label: .Education.forecastDiscussion, icon: .init("NOAALogo"))
                }
            }
            .listRowBackground(Color(uiColor: .secondarySystemFill).opacity(0.8))
        }
        .contentTransition(.opacity)
        .animation(.spring, value: response == nil)
        .animation(.spring, value: selectedOutlook)
        .scrollContentBackground(.hidden)
        .modifier(ConditionalNavigationTitleModifier(title: .riskDetails, displayMode: .inline, isEnabled: isFromSheet))
    }

    struct ConditionalNavigationTitleModifier: ViewModifier {
        let title: LocalizedStringResource
        let displayMode: NavigationBarItem.TitleDisplayMode
        let isEnabled: Bool

        func body(content: Content) -> some View {
            if isEnabled {
                content
                    .navigationTitle(title)
                    .navigationBarTitleDisplayMode(displayMode)
            } else {
                content
            }
        }
    }
}
