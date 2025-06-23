//
//  AboutCategoricalRiskView.swift
//  Redzone
//
//  Created by Greg Whatley on 2/10/24.
//

import SwiftUI

struct AboutCategoricalRiskView: View {
    @Environment(Context.self) private var context
    struct RiskDescriptionView: View {
        let title: String
        let description: String
        let style: Color
        
        var body: some View {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Label {
                        Text(title)
                            .font(.headline)
                    } icon: {
                        OutlookLegendIconView(fillColor: style, strokeColor: style)
                            .shadow(color: style.opacity(0.5), radius: 10)
                    }
                    Text(description)
                }
            }
        }
    }
    
    var body: some View {
        List {
            RiskDescriptionView(title: "General Thunderstorms", description: "10% or higher probability of thunderstorms is forecast.", style: .green.opacity(0.5))
            
            RiskDescriptionView(title: "Marginal", description: "Severe storms of either limited organization and logevety, or very low coverage and marginal intensity.", style: .green)
            
            RiskDescriptionView(title: "Slight", description: "Organized severe thunderstorms are expected, but usually in low coverage with varying levels of intensity.", style: .yellow)
            
            RiskDescriptionView(title: "Enhanced", description: "A greater concentration of organized severe thunderstorms with varying levels of intensity.", style: .orange)
            
            RiskDescriptionView(title: "Moderate", description: "Potential for widespread severe weather with several tornadoes and/or numerous severe thunderstorms, some of which may be intense.", style: .red)
            
            RiskDescriptionView(title: "High", description: "A severe weather outbreak is expected from either numerous intense and long-track tornadoes, or a long-lived derecho system with hurricane-force wind gusts producing widespread damage.", style: .magenta)
            
            SafetyLinksSection(tornado: false)
        }
        .scrollContentBackground(.visible)
        .navigationTitle("Categorical")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let ctx = Context()
    NavigationStack {
        AboutCategoricalRiskView()
            .environment(ctx)
    }
}
