//
//  SPCMapWidget.swift
//  SPCMapWidget
//
//  Created by Greg Whatley on 4/5/24.
//

import WidgetKit
import SwiftUI
import MapKit

struct DayOneOutlookWidget: Widget {
    let kind: String = "DayOneOutlookWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                DayOneOutlookWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                DayOneOutlookWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Current Location Outlook")
        .description("Displays the latest day 1 categorical convective outlook at your current location.")
    }
}

extension DayOneOutlookWidget {
    struct Provider: TimelineProvider {
        enum Entry: TimelineEntry {
            case outlook(Date, OutlookFeature?)
            case placeholder
            case error(EntryError)
            case snapshot
            
            var date: Date {
                return if case .outlook(let date, _) = self {
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

        func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
            completion(.snapshot)
        }

        func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
            Task {
                let returning = { (entry: Entry) in
                    completion(.init(entries: [entry], policy: .after(.now.addingTimeInterval(60 * 60 * 2))))
                }
                switch await OutlookFetcher.fetch(outlook: .convective1(.categorical)) {
                case .success(let response):
                    let outlooks = response.features
                        .filterNot(by: \.outlookProperties.isSignificant)
                        .sorted()
                        .reversed()
                    await MainActor.run {
                        WidgetLocation.shared.requestOneTimeLocation {
                            guard let location = $0 else {
                                returning(.error(.noLocation))
                                return
                            }
                            let outlook = outlooks.first {
                                    $0.geometry.lazy.compactCast(to: MKMultiPolygon.self).contains { $0.contains(point: .init(location.coordinate)) }
                                }
                            returning(.outlook(.now, outlook))
                        }
                    }
                default:
                    returning(.error(.unknown))
                }
            }
        }
    }
}
