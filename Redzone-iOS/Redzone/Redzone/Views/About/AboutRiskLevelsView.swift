//
//  AboutRiskLevelsView.swift
//  Redzone
//
//  Created by Greg Whatley on 11/26/25.
//

import RedzoneUI
import SwiftUI

struct AboutRiskLevelsView: View {
    var body: some View {
        List {
            RiskView(
                title: "General Thunderstorms",
                description: "10% or higher probability of thunderstorms is forecast.",
                color: .green.opacity(0.5)
            )
            RiskView(title: "Marginal", description: .Education.marginalDesc, color: .green)
            RiskView(title: "Slight", description: .Education.slightDesc, color: .yellow)
            RiskView(title: "Enhanced", description: .Education.enhancedDesc, color: .orange)
            RiskView(title: "Moderate", description: .Education.moderateDesc, color: .red)
            RiskView(title: "High", description: .Education.highDesc, color: .magenta)
        }
        .navigationTitle("Categorical")
        .navigationBarTitleDisplayMode(.inline)
    }
}
