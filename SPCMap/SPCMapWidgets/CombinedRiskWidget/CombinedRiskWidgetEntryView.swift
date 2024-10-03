//
//  CombinedRiskWidgetEntryView.swift
//  SPCMapWidgets
//
//  Created by Greg Whatley on 4/7/24.
//

import Foundation
import SwiftUI
import WidgetKit

struct CombinedRiskWidgetEntryView: WidgetFoundation.EntryView {
    typealias Provider = OutlookProvider
    typealias ErrorContent = WidgetErrorView
    
    var entry: Provider.Entry
    
    func mainContent(data: Provider.EntryData) -> some View {
        VStack(spacing: 4) {
            if let title = data.title,
               let value = data.value {
                content(
                    day: data.day,
                    risk: title,
                    value: value,
                    risks: data.risks
                )
            } else {
                Spacer()
                VStack(spacing: 1) {
                    NoSevereView()
                    DayLabel(day: data.day)
                }
                Spacer()
                DateLabel(entry: entry)
            }
        }
    }
}

extension CombinedRiskWidgetEntryView {
    func content(day: OutlookDay, risk: String?, value: Double, risks: CombinedRisks?) -> some View {
        GeometryReader { proxy in
            HStack {
                VStack(spacing: 1) {
                    Spacer()
                    if let risk {
                        CategoricalGaugeView(value: value, title: risk, day: day)
                    } else {
                        Circle()
                            .fill(.secondary.quaternary)
                            .frame(width: 50, height: 50)
                        Text("Placeholder")
                            .multilineTextAlignment(.center)
                            .font(.callout.weight(.medium))
                            .minimumScaleFactor(0.5)
                            .redacted(reason: .placeholder)
                    }
                    Spacer()
                    DateLabel(entry: entry)
                }
                .frame(width: proxy.size.width / 2 - 16)
                .padding(.leading, 4)
                Divider()
                    .padding(.horizontal, 4)
                VStack(alignment: .leading, spacing: 12) {
                    if let risks {
                        riskRow(image: "wind", label: "Wind Risk", info: risks.wind)
                        riskRow(image: "cloud.hail", label: "Hail Risk", info: risks.hail)
                        riskRow(image: "tornado", label: "Tornado Risk", info: risks.tornado)
                    } else {
                        riskRow(placeholder: "wind")
                        riskRow(placeholder: "cloud.hail")
                        riskRow(placeholder: "tornado")
                    }
                }
                .minimumScaleFactor(0.75)
                .lineLimit(1)
                .font(.subheadline)
                Spacer()
            }
        }
    }
    
    func riskRow(image: String, label: String, info: CombinedRisks.RiskInfo) -> some View {
        HStack(spacing: 2) {
            if info.isSignificant {
                Image(systemName: "exclamationmark.triangle.fill")
                    .symbolRenderingMode(.multicolor)
            } else {
                Image(systemName: image)
            }
            Text("\(info.percentage > .zero ? info.percentage.formatted() : "No") \(label)")
        }
    }
    
    func riskRow(placeholder image: String) -> some View {
        HStack {
            Image(systemName: image)
            Text("Placeholder")
                .redacted(reason: .placeholder)
        }
    }
}
