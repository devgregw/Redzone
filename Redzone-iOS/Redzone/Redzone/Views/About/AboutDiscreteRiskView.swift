//
//  AboutDiscreteRiskView.swift
//  Redzone
//
//  Created by Greg Whatley on 11/26/25.
//

import RedzoneCore
import RedzoneMacros
import RedzoneUI
import SwiftUI

struct AboutDiscreteRiskView: View {
    enum Risk: String {
        private static let standardLevels: [(Double, Color)] = [
            (0.05, .brown),
            (0.15, .yellow),
            (0.30, .red),
            (0.45, .magenta),
            (0.60, .purple)
        ]

        case wind = "Wind"
        case hail = "Hail"
        case tornado = "Tornado"
        case prob3 = "Probabilistic (Day 3)"
        case prob = "Probabilistic (Day 4-8)"

        init?(from classification: Convective.Classification) {
            switch classification {
            case .wind: self = .wind
            case .hail: self = .hail
            case .tornado: self = .tornado
            case .categorical: return nil
            @unknown default: return nil
            }
        }

        var description: LocalizedStringResource {
            switch self {
            case .wind: "Forecasted probability of damaging wind gusts of 50 knots (~60 miles per hour) or greater within 25 miles of a point."
            case .hail: "Forecasted probability of 1-inch diameter hail or larger within 25 miles of a point."
            case .tornado: "Forecasted probability of a tornado within 25 miles of a point."
            case .prob3: "Forecasted probability of severe weather within 25 miles of a point."
            case .prob: "A depicted severe weather area indicates 15%, 30% or higher probability for severe thunderstorms within 25 miles of a point."
            }
        }

        var levels: [(Double, Color)] {
            switch self {
            case .hail, .prob3: Self.standardLevels
            case .wind: [
                (0.05, .brown),
                (0.15, .yellow),
                (0.30, .red),
                (0.45, .magenta),
                (0.60, .purple),
                (0.75, .blue),
                (0.90, .cyan)
            ]
            case .tornado: [
                (0.02, .green),
                (0.05, .brown),
                (0.10, .yellow),
                (0.15, .red),
                (0.30, .magenta),
                (0.45, .purple),
                (0.60, .indigo)
            ]
            case .prob: [
                (0.15, .yellow),
                (0.30, .orange)
            ]
            }
        }
    }

    let risk: AboutDiscreteRiskView.Risk

    var body: some View {
        List {
            Section {
                Text(risk.description)
                ForEach(risk.levels, id: \.0) { level in
                    Label {
                        Text(level.0, format: .percent.precision(.fractionLength(0)))
                            .font(.headline)
                    } icon: {
                        OutlookLegendIconView(fillColor: level.1.opacity(0.5), strokeColor: level.1)
                            .shadow(color: level.1.opacity(0.5), radius: 10)
                    }
                }
            }

            if risk == .wind || risk == .hail || risk == .tornado || risk == .prob3 {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(.cigTitle)
                            .font(.headline)
                        Text(.cigExplanation)
                    }

                    Group {
                        switch risk {
                        case .wind:
                            Label(.windCig0, systemImage: "slash.circle", foregroundStyle: .secondary)
                            Label(.windCig1, systemImage: "exclamationmark", foregroundStyle: .red)
                            Label(.windCig2, systemImage: "exclamationmark.2", foregroundStyle: .red)
                            Label(.windCig3, systemImage: "exclamationmark.3", foregroundStyle: .red)
                        case .hail:
                            Label(.hailCig0, systemImage: "slash.circle", foregroundStyle: .secondary)
                            Label(.hailCig1, systemImage: "exclamationmark", foregroundStyle: .red)
                            Label(.hailCig2, systemImage: "exclamationmark.2", foregroundStyle: .red)
                        case .tornado:
                            Label(.tornadoCig0, systemImage: "slash.circle", foregroundStyle: .secondary)
                            Label(.tornadoCig1, systemImage: "exclamationmark", foregroundStyle: .red)
                            Label(.tornadoCig2, systemImage: "exclamationmark.2", foregroundStyle: .red)
                            Label(.tornadoCig3, systemImage: "exclamationmark.3", foregroundStyle: .red)
                        case .prob3:
                            Label(.cat3Cig0, systemImage: "slash.circle", foregroundStyle: .secondary)
                            Label(.cat3Cig1, systemImage: "exclamationmark", foregroundStyle: .red)
                            Label(.cat3Cig2, systemImage: "exclamationmark.2", foregroundStyle: .red)
                        default: EmptyView()
                        }
                    }
                    .symbolRenderingMode(.hierarchical)

                    ExternalLink(#URL("https://www.spc.noaa.gov/about/outlooks/SPC_Conditional_Intensity_Reference.pdf"), label: "Learn more")
                }
            }
        }
        .navigationTitle(risk.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
}
