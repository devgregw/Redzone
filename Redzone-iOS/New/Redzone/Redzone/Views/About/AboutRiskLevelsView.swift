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
        .init(title: "Marginal", description: "Severe storms of either limited organization and longevity, or very low coverage and marginal intensity.", color: .green),
        .init(title: "Slight", description: "Organized severe thunderstorms are expected, but usually in low coverage with varying levels of intensity.", color: .yellow),
        .init(title: "Enhanced", description: "A greater concentration of organized severe thunderstorms with varying levels of intensity.", color: .orange),
        .init(title: "Moderate", description: "Potential for widespread severe weather with several tornadoes and/or numerous severe thunderstorms, some of which may be intense.", color: .red),
        .init(title: "High", description: "A severe weather outbreak is expected from either numerous intense and long-track tornadoes, or a long-lived derecho system with hurricane-force wind gusts producing widespread damage.", color: .magenta)
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
