//
//  ConvectiveRiskWidget.swift
//  Redzone
//
//  Created by Greg Whatley on 10/2/24.
//

import SwiftUI
import WidgetKit

struct ConvectiveRiskWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: "dev.gregwhatley.redzone.ConvectiveRiskWidget", provider: OutlookProvider()) {
            ConvectiveRiskWidgetEntryView(entry: $0)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.accessoryRectangular, .accessoryInline, .systemSmall, .systemMedium])
        .configurationDisplayName("Convective Risk")
        .description("Displays the latest day 1 or day 2 convective outlooks at your current location.")
    }
}
