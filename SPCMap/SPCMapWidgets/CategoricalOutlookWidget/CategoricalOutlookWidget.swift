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

struct ConvectiveRiskWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: "dev.gregwhatley.spcapp.ConvectiveRiskWidget", provider: OutlookProvider()) {
            ConvectiveRiskWidgetEntryView(entry: $0)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.accessoryRectangular, .accessoryInline, .systemSmall, .systemMedium])
        .configurationDisplayName("Convective Risk")
        .description("Displays the latest day 1 or day 2 convective outlooks at your current location.")
    }
}

struct ConvectiveRiskWidgetEntryView: WidgetFoundation.EntryView {
    typealias Provider = OutlookProvider
    typealias ErrorContent = WidgetErrorView
    
    @Environment(\.widgetFamily) var widgetFamily
    let entry: Provider.Entry
    
    func mainContent(data: Provider.EntryData) -> some View {
        switch widgetFamily {
        case .accessoryRectangular, .accessoryInline:
            RiskBreakdownWidgetEntryView(entry: entry)
                .containerBackground(.regularMaterial, for: .widget)
        case .systemSmall:
            CategoricalOutlookWidgetEntryView(entry: entry)
                .containerBackground(.background, for: .widget)
        case .systemMedium:
            CombinedRiskWidgetEntryView(entry: entry)
                .containerBackground(.background, for: .widget)
        case .accessoryCircular:
            NoSevereView()
        default:
            UnsupportedWidgetFamilyView()
                .containerBackground(.background, for: .widget)
        }
    }
}

#if DEBUG
struct ConvectiveRiskWidget_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(WidgetFamily.allCases) { family in
            ConvectiveRiskWidgetEntryView(entry: .preview)
                .widgetPreview(as: family)
        }
    }
}
#endif
