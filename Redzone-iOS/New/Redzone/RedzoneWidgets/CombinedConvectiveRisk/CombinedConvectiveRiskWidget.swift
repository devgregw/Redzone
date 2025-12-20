//
//  CombinedConvectiveRiskWidget.swift
//  Redzone
//
//  Created by Greg Whatley on 11/28/25.
//

import AppIntents
import SwiftUI
import WidgetKit

struct CombinedConvectiveRiskWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: "dev.gregwhatley.redzone.CombinedConvectiveRiskWidget", provider: CombinedConvectiveRiskProvider()) {
            CombinedConvectiveRiskWidgetEntryView(entry: $0)
        }
        .configurationDisplayName("Convective Risks")
        .description("Displays the convective outlook details for your location.")
        .promptsForUserConfiguration()
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryCircular, .accessoryRectangular])
    }
}
