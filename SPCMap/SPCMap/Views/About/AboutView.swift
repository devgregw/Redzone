//
//  AboutView.swift
//  SPCMap
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
                    HStack(alignment: .center) {
                        Image("NOAALogo")
                            .resizable()
                            .frame(width: 65, height: 65)
                            .accessibilityHidden(true)
                        
                        VStack(alignment: .leading) {
                            Text("National Weather Service")
                                .font(.headline)
                            Text("Storm Prediction Center")
                                .font(.headline)
                            Text("U.S. Department of Commerce")
                                .font(.caption.bold().lowercaseSmallCaps())
                        }
                        .foregroundStyle(Color(.label))
                        .accessibilityElement(children: .combine)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.forward.square")
                    }
                }
            }
            
            RiskLevelLinksView()
            
            Section("Safety & Disclaimers") {
                NavigationLink {
                    DisclaimerView(launch: false)
                } label: {
                    Label("Disclaimer", systemImage: "briefcase")
                }
                LabelledLink("Safety for All Hazards", destination: "https://www.weather.gov/safety", systemImage: "staroflife")
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
