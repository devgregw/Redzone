//
//  SafetyLinksSection.swift
//  Redzone
//
//  Created by Greg Whatley on 5/25/25.
//

import SwiftUI

struct SafetyLinksSection: View {
    let tornado: Bool
    
    var body: some View {
        Section("Safety") {
            LabelledLink("Safety for All Hazards", destination: "https://www.weather.gov/safety", image: .nwsLogo)
            if tornado {
                LabelledLink("About The Enhanced Fujita (EF) Scale", destination: "https://www.spc.noaa.gov/efscale", image: .noaaLogo)
            }
            LabelledLink("Make a Plan", destination: "https://www.ready.gov/plan", image: .readyLogo)
            LabelledLink("SPC Products", destination: "https://www.spc.noaa.gov/misc/about.html", image: .noaaLogo)
        }
    }
}
