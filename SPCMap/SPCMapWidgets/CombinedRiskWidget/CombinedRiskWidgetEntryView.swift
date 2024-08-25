//
//  CombinedRiskWidgetEntryView.swift
//  SPCMapWidgets
//
//  Created by Greg Whatley on 4/7/24.
//

import Foundation
import SwiftUI
import WidgetKit

struct CombinedRiskWidgetEntryView : View {
    var entry: CombinedRiskWidget.Provider.Entry

    var dateString: String {
        entry.date.formatted(date: .numeric, time: .shortened)
    }
    
    var body: some View {
        VStack {
            switch entry {
            case .outlook(_, let day, let categorical, let risks):
                VStack {
                    if let categorical {
                        content(
                            day: day,
                            risk: categorical.outlookProperties.title,
                            value: categorical.outlookProperties.severity.comparableValue,
                            risks: risks
                        )
                    } else {
                        Spacer()
                        NoSevereView(day: day)
                        Spacer()
                        date
                    }
                }
                .widgetURL(.init(string: "whatley://spcapp?setOutlook=\(day.rawValue)"))
            case .placeholder:
                content(day: .day1, risk: nil, value: 0, risks: nil)
            case .error(let type):
                errorView(type)
            case .snapshot:
                content(day: .day1, risk: "Enhanced Risk", value: 3, risks: (wind: ("15% Wind Risk", false), hail: ("15% Hail Risk", false), tornado: ("30% Tornado Risk", true)))
            }
        }
    }
}

extension CombinedRiskWidgetEntryView {
    func content(day: OutlookDay, risk: String?, value: Double, risks: (wind: (String, Bool), hail: (String, Bool), tornado: (String, Bool))?) -> some View {
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
                    date
                }
                .frame(width: proxy.size.width / 2 - 16)
                .padding(.leading, 4)
                Divider()
                    .padding(.horizontal, 4)
                VStack(alignment: .leading, spacing: 12) {
                    if let risks {
                        riskRow(image: "wind", label: risks.wind.0, isSignificant: risks.wind.1)
                        riskRow(image: "cloud.hail", label: risks.hail.0, isSignificant: risks.hail.1)
                        riskRow(image: "tornado", label: risks.tornado.0, isSignificant: risks.tornado.1)
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
    
    @ViewBuilder var date: some View {
        HStack(spacing: 2) {
            if entry.showDate {
                Image(systemName: "clock")
                Text(dateString)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
            } else {
                Text("Placeholder")
                    .redacted(reason: .placeholder)
            }
        }
        .foregroundStyle(.secondary)
        .font(.caption2)
    }
    
    @ViewBuilder func errorView(_ type: EntryError) -> some View {
        Spacer()
        WidgetErrorView(error: type)
        Spacer()
        date
    }
    
    func riskRow(image: String, label: String, isSignificant: Bool) -> some View {
        HStack(spacing: 2) {
            if isSignificant {
                Image(systemName: "exclamationmark.triangle.fill")
                    .symbolRenderingMode(.multicolor)
            } else {
                Image(systemName: image)
            }
            Text(label)
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

#Preview(as: .systemMedium) {
    CombinedRiskWidget()
} timeline: {
    CombinedRiskWidget.Provider.Entry.snapshot
    CombinedRiskWidget.Provider.Entry.placeholder
    CombinedRiskWidget.Provider.Entry.outlook(.now, .day1, nil, nil)
    CombinedRiskWidget.Provider.Entry.error(.noLocation)
    CombinedRiskWidget.Provider.Entry.error(.unknown)
}
