//
//  AboutFireRiskView.swift
//  Redzone
//
//  Created by Greg Whatley on 2/7/26.
//

import RedzoneUI
import SwiftUI

struct AboutFireRiskView: View {
    var body: some View {
        List {
            RiskView(
                title: "Elevated",
                description: "Fire potential is great enough to pose a limited threat, but not enough to warrent a critical area.",
                color: .orange
            )
            RiskView(
                title: "Critical",
                description: "Strong winds and low relative humidity are expected to occur where dried fuels exist.",
                color: .red
            )
            RiskView(
                title: "Extremely Critical",
                description: "Very strong winds and very low relative humidity are expected to occur with very dry fuels.",
                color: .magenta
            )
        }
        .navigationTitle("Wind & Relative Humidity")
        .navigationBarTitleDisplayMode(.inline)
    }
}
