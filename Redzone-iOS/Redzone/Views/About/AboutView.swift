//
//  AboutView.swift
//  Redzone
//
//  Created by Greg Whatley on 4/2/23.
//

import SwiftUI

struct AboutView: View {
    @Environment(Context.self) private var context
    
    var body: some View {
        List {
            Section("Data Source") {
                Link(destination: URL(string: "https://spc.noaa.gov")!) {
                    HStack {
                        Image(.nwsLogo)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .accessibilityHidden(true)
                        VStack(alignment: .leading) {
                            Text("National Weather Service")
                                .font(.headline)
                            Text("Storm Prediction Center")
                                .font(.subheadline)
                        }
                        .foregroundStyle(Color(.label))
                        Spacer()
                        Image(systemName: "arrow.up.forward.square")
                            .accessibilityHidden(true)
                    }
                    .accessibilityElement(children: .combine)
                }
                
                Link(destination: URL(string: "https://noaa.gov")!) {
                    HStack {
                        Image(.noaaLogo)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .accessibilityHidden(true)
                        VStack(alignment: .leading) {
                            Text("National Oceanic and Atmospheric Administration")
                                .font(.headline)
                        }
                        .foregroundStyle(Color(.label))
                        Spacer()
                        Image(systemName: "arrow.up.forward.square")
                            .accessibilityHidden(true)
                    }
                    .accessibilityElement(children: .combine)
                }
            }
            
            Section("Safety & Disclaimers") {
                NavigationLink {
                    DisclaimerView(launch: false)
                } label: {
                    Label("Disclaimer", systemImage: "briefcase")
                }
                LabelledLink("Safety for All Hazards", destination: "https://www.weather.gov/safety", image: .nwsLogo)
            }
            
            RiskLevelLinksView()
            
            Section {
                LabelledLink("About Me", destination: "https://gregwhatley.dev", image: .me)
                LabelledLink("Source Code", destination: "https://github.com/devgregw/Redzone", image: .gitHubLogo)
            }
            
            Section {
                HStack {
                    Text("Version")
                    Spacer()
#if DEBUG
                    (Text(Bundle.main.versionString) + Text("DEBUG"))
                        .monospaced()
#else
                    Text(Bundle.main.versionString)
                        .monospaced()
#endif
                }
            }
            .foregroundStyle(.primary.opacity(0.8))
            .font(.footnote)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowSpacing(.zero)
            .listRowInsets(EdgeInsets())
        }
        .scrollContentBackground(.visible)
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    let ctx = Context()
    NavigationStack {
        AboutView()
            .environment(ctx)
    }
}
