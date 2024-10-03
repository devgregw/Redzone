//
//  CategoricalOutlookWidget.swift
//  SPCMapWidgets
//
//  Created by Greg Whatley on 4/5/24.
//

import WidgetKit
import SwiftUI
import GeoJSON

struct CategoricalOutlookWidget: Widget {
    let kind: String = "DayOneOutlookWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, provider: OutlookProvider()) { entry in
            CategoricalOutlookWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Categorical Outlook")
        .description("Displays the latest day 1 or day 2 categorical convective outlook at your current location.")
    }
}
