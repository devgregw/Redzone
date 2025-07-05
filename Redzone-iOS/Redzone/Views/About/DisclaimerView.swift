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
                    Text("Redzone displays and represents publicly available data from the National Weather Service, primarily from its Storm Prediction Center (SPC) office. The Redzone app and I, Gregory Whatley, are neither endorsed by nor affiliated with the National Weather Service or any other United States federal government organization.")
                    Text("By using Redzone, you assume the entire risk associated with the use of this data.")
                    Text("Redzone and all data provided herein by the NWS are provided “as-is,” without warranty of any kind, express or implied, including but not limited to the warranties of merchantability or fitness for a particular purpose. In no event should I be liable to you or to any third party for any direct, indirect, incidental, consequential, special, or exemplary damages or lost profit resulting from any use or misuse of this data. For more information, please see the National Weather Service's own disclaimer.")
                    Text("© 2025 Gregory Whatley. In accordance with 17 U.S.C. § 403, portions of Redzone incoprorate works of the United States government - namely raw risk outlook data (including geograpical coordinates, colors, names, and descriptions) and agency logos used solely to identify links to their respective websites - which are not subject to copyright protection. Copyright is claimed only in the original content authored by Gregory Whatley. Redzone source code is licensed under the MIT License.")
                }
                
                LabelledLink("NWS Disclaimer", destination: "https://www.weather.gov/disclaimer", image: "NWSLogo")
            }
            
            Section("Safety") {
                Text("Always have a plan and be prepared to take action in the event of severe weather. Use these resources to learn more about weather safety and plan ahead.")
                
                LabelledLink("Safety for All Hazards", destination: "https://www.weather.gov/safety", image: "NWSLogo")
                LabelledLink("Make a Plan", destination: "https://www.ready.gov/plan", image: "ReadyLogo")
                LabelledLink("SPC Products", destination: "https://www.spc.noaa.gov/misc/about.html", image: "NOAALogo")
            }
            
            Section("Privacy") {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Redzone does not collect and store any of your personal information. You may choose to share your current location with Redzone, which is used to pinpoint your location on the map and provide information about outlooks at your location. This processing is done exclusively on your device. While Lock Screen & Home Screen widgets require location services, the core features of Redzone will remain functional if you choose to not share your location.")
                    Text("If you interact with an external link from Redzone, the privacy policy of that website will apply.")
                }
                
                LabelledLink("NWS Privacy Policy", destination: "https://www.weather.gov/privacy", image: "NWSLogo")
                LabelledLink("Protecting Your Privacy", destination: "https://www.noaa.gov/protecting-your-privacy", image: "NOAALogo")
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
