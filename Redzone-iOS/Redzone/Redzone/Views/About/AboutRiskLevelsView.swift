//
//  AboutRiskLevelsView.swift
//  Redzone
//
//  Created by Greg Whatley on 11/26/25.
//

import RedzoneUI
import SwiftUI

struct AboutRiskLevelsView: View {
    private struct RiskView: View, Hashable {
        let title: LocalizedStringResource
        let description: LocalizedStringResource
        let color: Color

        func hash(into hasher: inout Hasher) {
            hasher.combine(title.key)
            hasher.combine(description.key)
            hasher.combine(color)
        }

        static func == (lhs: RiskView, rhs: RiskView) -> Bool {
            lhs.hashValue == rhs.hashValue
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Label {
                    Text(title)
                        .font(.headline)
                } icon: {
                    OutlookLegendIconView(fillColor: color, strokeColor: color)
                        .shadow(color: color.opacity(0.5), radius: 10)
                }
                Text(description)
            }
        }
    }

    private static let risks: [RiskView] = [
        .init(title: "General Thunderstorms", description: "10% or higher probability of thunderstorms is forecast.", color: .green.opacity(0.5)),
        .init(title: "Marginal", description: .Education.marginalDesc, color: .green),
        .init(title: "Slight", description: .Education.slightDesc, color: .yellow),
        .init(title: "Enhanced", description: .Education.enhancedDesc, color: .orange),
        .init(title: "Moderate", description: .Education.moderateDesc, color: .red),
        .init(title: "High", description: .Education.highDesc, color: .magenta)
    ]

    var body: some View {
        List {
            ForEach(Self.risks, id: \.self) {
                $0
            }
        }
        .navigationTitle("Categorical")
        .navigationBarTitleDisplayMode(.inline)
    }
}
