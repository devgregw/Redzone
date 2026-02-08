//
//  AboutView.swift
//  Redzone
//
//  Created by Greg Whatley on 10/25/25.
//

import RedzoneCore
import RedzoneMacros
import RedzoneUI
import SwiftUI
import WatchConnectivity
import WidgetKit

struct AboutView: View {
    #if DEBUG
    // periphery:ignore - false positive
    @AppStorage("didAcknowledgeDisclaimer") private var didAcknowledgeDisclaimer: Bool = false
    #endif

    var body: some View {
        NavigationStack {
            List {
                Section("Data Source") {
                    ExternalLink(#URL("https://spc.noaa.gov"), icon: Image(.nwsLogo)) {
                        Text("Storm Prediction Center")
                            .font(.headline)
                        Text("National Weather Service")
                            .font(.subheadline)
                    }

                    ExternalLink(#URL("https://noaa.gov"), icon: Image(.noaaLogo)) {
                        Text("National Oceanic and Atmospheric Administration")
                            .font(.headline)
                    }

                    NavigationLink {
                        DisclaimerView()
                    } label: {
                        Label("Disclaimer", systemImage: "briefcase")
                    }
                }

                Section("Safety") {
                    ExternalLink(#URL("https://www.weather.gov/safety"), label: "Safety for All Hazards", icon: Image(.nwsLogo))
                    ExternalLink(#URL("https://www.ready.gov/plan"), label: "Make a Plan", icon: Image(.readyLogo))
                    ExternalLink(#URL("https://www.spc.noaa.gov/misc/about.html"), label: "SPC Products", icon: Image(.noaaLogo))
                }

                Section {
                    NavigationLink {
                        AboutRiskLevelsView()
                    } label: {
                        Label("Categorical", systemImage: "square.3.layers.3d.down.right")
                    }

                    NavigationLink {
                        AboutDiscreteRiskView(risk: .wind)
                    } label: {
                        Label("Wind", systemImage: "wind")
                    }

                    NavigationLink {
                        AboutDiscreteRiskView(risk: .hail)
                    } label: {
                        Label("Hail", systemImage: "cloud.hail")
                    }

                    NavigationLink {
                        AboutDiscreteRiskView(risk: .tornado)
                    } label: {
                        Label("Tornado", systemImage: "tornado")
                    }

                    NavigationLink {
                        AboutDiscreteRiskView(risk: .prob3)
                    } label: {
                        Label("Probabilistic (Day 3)", systemImage: "umbrella.percent")
                    }

                    NavigationLink {
                        AboutDiscreteRiskView(risk: .prob)
                    } label: {
                        Label("Probabilistic (Day 4-8)", systemImage: "umbrella.percent")
                    }

                    NavigationLink {
                        AboutSevTStormView()
                    } label: {
                        Label(.Education.severeTstormLink, systemImage: "questionmark.circle")
                    }
                } header: {
                    Label("Convective Risks", systemImage: "bolt.trianglebadge.exclamationmark")
                }

                Section {
                    NavigationLink {
                        AboutFireRiskView()
                    } label: {
                        Label("Wind & Relative Humidity", systemImage: "humidity")
                    }
                } header: {
                    Label("Fire Risks", systemImage: "flame")
                }

                Section {
                    ExternalLink(#URL("https://github.com/devgregw/Redzone"), label: "Source Code", icon: Image(.gitHubLogo))
                }

                #if DEBUG
                Section("Testing Tools") {
                    Button("Reset disclaimer acknowledgement") {
                        didAcknowledgeDisclaimer = false
                    }

                    Button("Reload widgets") {
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                }
                #endif

                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(versionOf: .main)
                        #if DEBUG
                        Text("DEBUG")
                            .bold()
                        #endif
                    }
                    .foregroundStyle(.primary.opacity(0.8))
                    .font(.footnote)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

extension Text {
    init(versionOf bundle: Bundle) {
        guard let shortVersion = bundle.infoDictionary?["CFBundleShortVersionString"] as? String,
              let buildVersion = bundle.infoDictionary?["CFBundleVersion"] as? String else {
            self.init("--")
            return
        }

        self.init("\(shortVersion) (\(buildVersion))")
    }
}

#Preview {
    AboutView()
}
