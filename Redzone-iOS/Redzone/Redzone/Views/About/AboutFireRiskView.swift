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
                description: LocalizedStringResource.fireElevatedDesc,
                color: .orange
            )
            RiskView(
                title: "Critical",
                description: LocalizedStringResource.fireCriticalDesc,
                color: .red
            )
            RiskView(
                title: "Extremely Critical",
                description: LocalizedStringResource.fireExtmCriticalDesc,
                color: .magenta
            )
        }
        .navigationTitle("Wind & Relative Humidity")
        .navigationBarTitleDisplayMode(.inline)
    }
}
