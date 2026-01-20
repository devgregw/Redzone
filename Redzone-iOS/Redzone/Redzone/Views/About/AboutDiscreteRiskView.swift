//
//  AboutDiscreteRiskView.swift
//  Redzone
//
//  Created by Greg Whatley on 11/26/25.
//

import RedzoneCore
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
            case .wind, .hail, .prob3: Self.standardLevels
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

        var sigDescription: LocalizedStringResource? {
            switch self {
            case .wind: .Education.sigWindDesc
            case .hail: .Education.sigHailDesc
            case .tornado: .Education.sigTornadoDesc
            case .prob3: .Education.sigProb3Desc
            case .prob: nil
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
                        OutlookLegendIconView(fillColor: level.1, strokeColor: level.1)
                            .shadow(color: level.1.opacity(0.5), radius: 10)
                    }
                }
            }

            if let sigDesc = risk.sigDescription {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Label {
                            HStack(spacing: 4) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .symbolRenderingMode(.multicolor)
                                Text("Significant Severe")
                                    .font(.headline)
                            }
                        } icon: {
                            SigSevLegendIconView()
                        }
                        Text(sigDesc)
                    }
                }
            }
        }
        .navigationTitle(risk.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
}
