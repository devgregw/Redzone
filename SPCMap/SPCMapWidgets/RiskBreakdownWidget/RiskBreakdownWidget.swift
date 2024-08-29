//
//  RiskBreakdownWidget.swift
//  SPCMapWidgets
//
//  Created by Greg Whatley on 8/17/24.
//

import SwiftUI
import WidgetKit

struct RiskBreakdownWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: "RiskBreakdownWidget", provider: OutlookProvider()) { entry in
            RiskBreakdownWidgetEntryView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .supportedFamilies([.accessoryInline, .accessoryRectangular])
        .configurationDisplayName("Combined Risks")
        .description("Displays the latest day 1 or day 2 convective wind, hail, and tornado outlooks at your current location.")
    }
}
