//
//  RiskLevelLinksView.swift
//  SPCMap
//
//  Created by Greg Whatley on 2/10/24.
//

import SwiftUI

struct RiskLevelLinksView: View {
    var body: some View {
        Section("Risk Levels") {
            NavigationLink {
                AboutCategoricalRiskView()
            } label: {
                Label("Categorical", systemImage: "square.stack.3d.down.forward")
            }
            NavigationLink {
                PercentageRiskDetailView.wind
            } label: {
                Label("Wind", systemImage: "wind")
            }
            NavigationLink {
                PercentageRiskDetailView.hail
            } label: {
                Label("Hail", systemImage: "cloud.hail")
            }
            NavigationLink {
                PercentageRiskDetailView.tornado
            } label: {
                Label("Tornado", systemImage: "tornado")
            }
            NavigationLink {
                PercentageRiskDetailView.probabilistic3
            } label: {
                Label("Probabilistic (Day 3)", systemImage: "percent")
            }
            NavigationLink {
                PercentageRiskDetailView.probabilistic48
            } label: {
                Label("Probabilistic (Day 4-8)", systemImage: "percent")
            }
        }
    }
}

#Preview {
    NavigationStack {
        List {
            RiskLevelLinksView()
        }
    }
}
