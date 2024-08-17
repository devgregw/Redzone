//
//  CategoricalOutlookWidgetEntryView.swift
//  SPCMapWidgets
//
//  Created by Greg Whatley on 4/7/24.
//

import Foundation
import SwiftUI
import WidgetKit

struct CategoricalOutlookWidgetEntryView : View {
    var entry: CategoricalOutlookWidget.Provider.Entry

    var dateString: String {
        entry.date.formatted(date: .numeric, time: .shortened)
    }
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 1) {
                switch entry {
                case .outlook(let day, _, let feature):
                    outlook(day: day, feature: feature)
                        .widgetURL(.init(string: "whatley://spcapp?setOutlook=\(day.rawValue)"))
                case .snapshot: CategoricalGaugeView(value: 3, title: "Enhanced Risk", day: .day1)
                case .placeholder: placeholder
                case .error(let type): WidgetErrorView(error: type)
                }
            }
            Spacer()
            date
        }
    }
}

extension CategoricalOutlookWidgetEntryView {
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
    
    @ViewBuilder func outlook(day: OutlookDay, feature: OutlookFeature?) -> some View {
        if let feature {
            CategoricalGaugeView(value: feature.outlookProperties.severity.comparableValue, title: feature.outlookProperties.title, day: day)
        } else {
            NoSevereView(day: day)
        }
    }
    
    @ViewBuilder var placeholder: some View {
        Circle()
            .fill(.secondary.quaternary)
            .frame(width: 50, height: 50)
        Text("Placeholder")
            .multilineTextAlignment(.center)
            .font(.callout.weight(.medium))
            .minimumScaleFactor(0.5)
            .redacted(reason: .placeholder)
    }
}

#Preview(as: .systemSmall) {
    CategoricalOutlookWidget()
} timeline: {
    CategoricalOutlookWidget.Provider.Entry.snapshot
    CategoricalOutlookWidget.Provider.Entry.placeholder
    CategoricalOutlookWidget.Provider.Entry.outlook(.day1, .now, nil)
    CategoricalOutlookWidget.Provider.Entry.error(.noLocation)
    CategoricalOutlookWidget.Provider.Entry.error(.unknown)
}
