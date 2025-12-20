//
//  EducationSection.swift
//  Redzone
//
//  Created by Greg Whatley on 9/30/25.
//

import SwiftUI
import RedzoneCore
import RedzoneUI

struct EducationSection: View {
    @CodableAppStorage("selectedOutlookType") private var selectedOutlookType = OutlookType.convective(.day1(.categorical))

    var body: some View {
        Section {
            NavigationLink {
                switch selectedOutlookType {
                case .convective(let type):
                    switch type {
                    case .day1(.categorical), .day2(.categorical), .day3(probabilistic: false):
                        AboutRiskLevelsView()
                    case .day1(let classification), .day2(let classification):
                        if let risk: AboutDiscreteRiskView.Risk = .init(from: classification) {
                            AboutDiscreteRiskView(risk: risk)
                        }
                    case .day3(probabilistic: true):
                        AboutDiscreteRiskView(risk: .prob3)
                    case .day4, .day5, .day6, .day7, .day8:
                        AboutDiscreteRiskView(risk: .prob)
                    @unknown default: EmptyView()
                    }
                @unknown default: EmptyView()
                }
            } label: {
                Label("About This Risk", systemImage: "questionmark.circle")
            }

            ExternalLink(selectedOutlookType.commentaryURL, label: .Education.forecastDiscussion, icon: .init("NOAALogo"))
        }
        .listRowBackground(Color(uiColor: .secondarySystemFill).opacity(0.8))
    }
}
