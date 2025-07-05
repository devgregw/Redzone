//
//  DisclaimerView.swift
//  Redzone
//
//  Created by Greg Whatley on 4/18/25.
//

import SwiftUI

struct DisclaimerView: View {
    @Environment(\.dismiss) var dismiss
    let launch: Bool
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 16) {
                    Text(.disclaimerAffiliation)
                    Text(.disclaimerUse)
                    Text(.disclaimerLiability)
                    Text(.disclaimerCopyright)
                }
                
                LabelledLink("NWS Disclaimer", destination: "https://www.weather.gov/disclaimer", image: .nwsLogo)
            }
            
            Section("Safety") {
                Text(.disclaimerSafety)
                
                LabelledLink("Safety for All Hazards", destination: "https://www.weather.gov/safety", image: .nwsLogo)
                LabelledLink("Make a Plan", destination: "https://www.ready.gov/plan", image: .readyLogo)
                LabelledLink("SPC Products", destination: "https://www.spc.noaa.gov/misc/about.html", image: .noaaLogo)
            }
            
            Section("Privacy") {
                VStack(alignment: .leading, spacing: 16) {
                    Text(.disclaimerPrivacy)
                    Text(.disclaimerPrivacyExternal)
                }
                
                LabelledLink("NWS Privacy Policy", destination: "https://www.weather.gov/privacy", image: .nwsLogo)
                LabelledLink("Protecting Your Privacy", destination: "https://www.noaa.gov/protecting-your-privacy", image: .noaaLogo)
            }
        }
        .navigationTitle("Disclaimer")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if launch {
                ToolbarItem(placement: .bottomBar) {
                    Button("I Understand", action: dismiss.callAsFunction)
                }
            }
        }
        .scrollContentBackground(.visible)
    }
}

#Preview {
    NavigationStack {
        DisclaimerView(launch: true)
    }
}
