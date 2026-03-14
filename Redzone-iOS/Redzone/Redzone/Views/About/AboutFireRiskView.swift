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
            Section {
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
            } header: {
                Label("Wind & Relative Humidity", systemImage: "humidity")
            }

            Section {
                RiskView(
                    title: "Isolated",
                    description: LocalizedStringResource.fireIsoDryTDesc,
                    color: Color(hex: "#824A19")
                )
                RiskView(
                    title: "Scattered",
                    description: LocalizedStringResource.fireSctDryTDesc,
                    color: Color(hex: "#44087D")
                )
            } header: {
                Label("Dry Thunderstorms", systemImage: "cloud.bolt")
            }
        }
        .navigationTitle("Categorical")
        .navigationBarTitleDisplayMode(.inline)
    }
}
