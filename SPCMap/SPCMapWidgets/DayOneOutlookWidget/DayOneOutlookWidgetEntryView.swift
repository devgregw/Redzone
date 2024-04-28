//
//  DayOneOutlookWidgetEntryView.swift
//  SPCMapWidgets
//
//  Created by Greg Whatley on 4/7/24.
//

import Foundation
import SwiftUI
import WidgetKit

struct DayOneOutlookWidgetEntryView : View {
    var entry: DayOneOutlookWidget.Provider.Entry

    var dateString: String {
        entry.date.formatted(date: .numeric, time: .shortened)
    }
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 1) {
                switch entry {
                case .outlook(_, let feature): outlook(day: .day1, feature: feature)
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

extension DayOneOutlookWidgetEntryView {
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
    DayOneOutlookWidget()
} timeline: {
    DayOneOutlookWidget.Provider.Entry.snapshot
    DayOneOutlookWidget.Provider.Entry.placeholder
    DayOneOutlookWidget.Provider.Entry.outlook(.now, nil)
    DayOneOutlookWidget.Provider.Entry.error(.noLocation)
    DayOneOutlookWidget.Provider.Entry.error(.unknown)
}
