//
//  CategoricalOutlookWidget.swift
//  SPCMapWidgets
//
//  Created by Greg Whatley on 4/5/24.
//

import WidgetKit
import SwiftUI
import MapKit

struct CategoricalOutlookWidget: Widget {
    let kind: String = "DayOneOutlookWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: OutlookDayConfigurationIntent.self, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                CategoricalOutlookWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                CategoricalOutlookWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Categorical Outlook")
        .description("Displays the latest day 1 or day 2 categorical convective outlook at your current location.")
    }
}

extension CategoricalOutlookWidget {
    struct Provider: AppIntentTimelineProvider {
        typealias Intent = OutlookDayConfigurationIntent
        
        enum Entry: TimelineEntry {
            case outlook(OutlookDay, Date, OutlookFeature?)
            case placeholder
            case error(EntryError)
            case snapshot
            
            var date: Date {
                return if case .outlook(_, let date, _) = self {
                    date
                } else {
                    .init(timeIntervalSinceNow: -3600)
                }
            }
            
            var showDate: Bool {
                return switch self {
                case .placeholder, .error: false
                default: true
                }
            }
        }
        
        func placeholder(in context: Context) -> Entry {
            .placeholder
        }
        
        func snapshot(for configuration: OutlookDayConfigurationIntent, in context: Context) async -> Entry {
            .snapshot
        }

        func timeline(for configuration: OutlookDayConfigurationIntent, in context: Context) async -> Timeline<Entry> {
            let makeTimeline = { (entry: Entry) -> Timeline<Entry> in
                Timeline(entries: [entry], policy: .after(.now.addingTimeInterval(60 * 60 * 2)))
            }
            switch await OutlookFetcher.fetch(outlook: .convective1(.categorical)) {
            case .success(let response):
                let outlooks = response.features
                    .filterNot(by: \.outlookProperties.isSignificant)
                    .sorted()
                    .reversed()
                guard let location = await WidgetLocation.shared.requestOneTimeLocation() else {
                    return makeTimeline(.error(.noLocation))
                }
                let outlook = outlooks.first {
                    $0.geometry.lazy.compactCast(to: MKMultiPolygon.self).contains { $0.contains(point: .init(location.coordinate)) }
                }
                return makeTimeline(.outlook(configuration.day, .now, outlook))
            default:
                return makeTimeline(.error(.unknown))
            }
        }
    }
}
