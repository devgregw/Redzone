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
                        Image("NWSLogo", bundle: .main)
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
                        Image("NOAALogo", bundle: .main)
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
            
            Section {
                LabelledLink("About Me", destination: "https://gregwhatley.dev", image: "Me")
                LabelledLink("Source Code", destination: "https://github.com/devgregw/Redzone", image: "GitHubLogo")
            }
            
            RiskLevelLinksView()
            
            Section("Safety & Disclaimers") {
                NavigationLink {
                    DisclaimerView(launch: false)
                } label: {
                    Label("Disclaimer", systemImage: "briefcase")
                }
                LabelledLink("Safety for All Hazards", destination: "https://www.weather.gov/safety", image: "NWSLogo")
            }
        }
        .scrollContentBackground(.visible)
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let ctx = Context()
    NavigationStack {
        AboutView()
            .environment(ctx)
    }
}
