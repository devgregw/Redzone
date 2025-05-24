//
//  DisclaimerView.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/18/25.
//

import SwiftUI

struct DisclaimerView: View {
    @Environment(\.dismiss) var dismiss
    let launch: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("SPCMap displays and represents publicly available data from the National Weather Service, primarily from its Storm Prediction Center (SPC) office. The SPCMap app and I, Gregory Whatley, are neither endorsed by nor affiliated with the National Weather Service or any other United States federal government organization.")
                Text("By continuing to use SPCMap, you assume the entire risk associated with the use of this data.")
                Text("SPCMap and all data provided herein by the NWS are provided “as-is,” without warranty of any kind, express or implied, including but not limited to the warranties of merchantability or fitness for a particular purpose. In no event should I nor the NWS be liable to you or to any third party for any direct, indirect, incidental, consequential, special, or exemplary damages or lost profit resulting from any use or misuse of this data.")
                LabelledLink("NWS Disclaimer", destination: "https://www.weather.gov/disclaimer", systemImage: "text.book.closed")
                
                Divider()
                
                Text("Safety")
                    .font(.title.bold())
                Text("Always have a plan and be prepared to take action in the event of severe weather. Use these resources to learn more about weather safety and plan ahead.")
                LabelledLink("Safety for All Hazards", destination: "https://www.weather.gov/safety", systemImage: "staroflife")
                LabelledLink("Make A Plan", destination: "https://www.ready.gov/plan", systemImage: "shield")
                LabelledLink("SPC Products", destination: "https://www.spc.noaa.gov/misc/about.html", systemImage: "list.clipboard")
                
                Divider()
                
                Text("Privacy")
                    .font(.title.bold())
                Text("SPCMap does not collect and store any of your personal information. You may choose to share your current location with SPCMap, which it uses to show your location on the map and provide information about outlooks covering your location. This processing is done exclusively on your device. Lock Screen & Home Screen widgets require location services, but the remaining features of SPCMap will remain functional if you choose to not share your location.")
                Text("If you interact with an external link from SPCMap, the privacy policy of that website will apply.")
                LabelledLink("NWS Privacy Policy", destination: "https://www.weather.gov/privacy", systemImage: "network.badge.shield.half.filled")
            }
            .padding()
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
    }
}

#Preview {
    NavigationStack {
        DisclaimerView(launch: true)
    }
}
