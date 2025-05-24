//
//  PercentageRiskDetailView.swift
//  SPCMap
//
//  Created by Greg Whatley on 2/10/24.
//

import SwiftUI

struct PercentageRiskDetailView: View {
    @Environment(Context.self) private var context
    
    let title: String
    let description: String
    let levels: [(Int, Color)]
    let sigSevereDescription: String?
    
    init(title: String, description: String, levels: [(Int, Color)], sigSevereDescription: String? = nil) {
        self.title = title
        self.description = description
        self.levels = levels
        self.sigSevereDescription = sigSevereDescription
    }
    
    var body: some View {
        List {
            Section {
                Text(description)
                ForEach(levels, id: \.0) { level in
                    Label {
                        Text("\(level.0)%")
                            .font(.headline)
                    } icon: {
                        OutlookLegendIconView(fillColor: level.1, strokeColor: level.1)
                            .shadow(color: level.1.opacity(0.5), radius: 10)
                    }
                }
            }
            
            if let sigSevereDescription {
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
                        Text(sigSevereDescription)
                    }
                }
            }
            
            Section("Safety") {
                LabelledLink("Safety for All Hazards", destination: "https://www.weather.gov/safety", systemImage: "staroflife")
                if title.contains("Tornado") {
                    LabelledLink("About The Enhanced Fujita (EF) Scale", destination: "https://www.spc.noaa.gov/efscale", systemImage: "tornado")
                }
            }
        }
        .scrollContentBackground(.visible)
        .navigationTitle(title)
    }
}

#Preview {
    NavigationStack {
        PercentageRiskDetailView.wind
    }
}

extension PercentageRiskDetailView {
    private static let standardLevels: [(Int, Color)] = [
        (5, .brown),
        (15, .yellow),
        (30, .red),
        (45, .magenta),
        (60, .purple)
    ]
    
    static let wind: PercentageRiskDetailView = PercentageRiskDetailView(
        title: "Wind",
        description: "Wind risk is measured on a scale of 5%, 15%, 30%, 45%, and 60% with each percentage represening the forecasted probably of damaging wind gusts of 50 knots (~60 miles per hour) or greater within 25 miles of a point.",
        levels: standardLevels,
        sigSevereDescription: "A significant severe region represents 10% or greater probability of 65-knot (~75 miles per hour) or greater wind gusts within 25 miles of a point. This region is represented separately from the percentage regions and may overlap with them."
    )
    
    static let hail: PercentageRiskDetailView = PercentageRiskDetailView(
        title: "Hail",
        description: "Hail risk is measured on a scale of 5%, 15%, 30%, 45%, and 60% with each percentage represening the forecasted probably of 1-inch diameter hail or larger within 25 miles of a point.",
        levels: standardLevels,
        sigSevereDescription: "A significant severe region represents 10% or greater probability of 2-inch diameter hail or larger within 25 miles of a point. This region is represented separately from the percentage regions and may overlap with them."
    )
    
    static let tornado: PercentageRiskDetailView = PercentageRiskDetailView(
        title: "Tornado",
        description: "Tornado risk is measured on a scale of 2%, 5%, 10%, 15%, 30%, 45%, and 60% with each percentage represening the forecasted probably of a tornado within 25 miles of a point.",
        levels: [
            (2, .green),
            (5, .brown),
            (10, .yellow),
            (15, .red),
            (30, .magenta),
            (45, .purple),
            (60, .indigo)
        ],
        sigSevereDescription: "A significant severe region represents 10% or greater probability of EF2 - EF5 tornadoes within 25 miles of a point. This region is represented separately from the percentage regions and may overlap with them."
    )
    
    static let probabilistic3: PercentageRiskDetailView = PercentageRiskDetailView(
        title: "Probabilistic (Day 3)",
        description: "Probability of severe weather within 25 miles of a point.",
        levels: standardLevels,
        sigSevereDescription: "A significant severe region represents 10% or greater probability of significant severe weather within 25 miles of a point. This region is represented separately from the percentage regions and may overlap with them."
    )
    
    static let probabilistic48: PercentageRiskDetailView = PercentageRiskDetailView(
        title: "Probabilistic (Day 4-8)",
        description: "A depicted severe weather area indicates 15%, 30% or higher probability for severe thunderstorms within 25 miles of a point.",
        levels: [
            (15, .yellow),
            (30, .orange)
        ]
    )
}
