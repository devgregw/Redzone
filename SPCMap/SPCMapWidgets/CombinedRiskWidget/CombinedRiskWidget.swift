//
//  CombinedRiskWidget.swift
//  SPCMapWidgets
//
//  Created by Greg Whatley on 4/7/24.
//

import WidgetKit
import SwiftUI
import MapKit

struct CombinedRiskWidget: Widget {
    let kind: String = "CombinedRiskWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: OutlookDayConfigurationIntent.self, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                CombinedRiskWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                CombinedRiskWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("Combined Risks")
        .description("Displays the latest day 1 or day 2 convective categorical, wind, hail, and tornado outlooks at your current location.")
    }
}

extension CombinedRiskWidget {
    struct Provider: AppIntentTimelineProvider {
        typealias Intent = OutlookDayConfigurationIntent
        
        enum Entry: TimelineEntry {
            case outlook(Date, OutlookDay, OutlookFeature?, (wind: (String, Bool), hail: (String, Bool), tornado: (String, Bool))?)
            case placeholder
            case error(EntryError)
            case snapshot
            
            var date: Date {
                return if case .outlook(let date, _, _, _) = self {
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
        
        func getOutlook(day: OutlookDay, type: OutlookType.ConvectiveOutlookType) async -> [OutlookFeature]? {
            return switch await OutlookFetcher.fetch(outlook: day == .day1 ? .convective1(type) : .convective2(type)) {
            case .success(let response): response.features.sorted().reversed()
            default: nil
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
            if let categoricalResponse = await getOutlook(day: configuration.day, type: .categorical) {
                let windResponse = await self.getOutlook(day: configuration.day, type: .wind)
                let hailResponse = await self.getOutlook(day: configuration.day, type: .hail)
                let tornResponse = await self.getOutlook(day: configuration.day, type: .tornado)
                let categoricalOutlooks = categoricalResponse.filterNot(by: \.outlookProperties.isSignificant)
                let windOutlooks = windResponse?.filterNot(by: \.outlookProperties.isSignificant)
                let hailOutlooks = hailResponse?.filterNot(by: \.outlookProperties.isSignificant)
                let tornOutlooks = tornResponse?.filterNot(by: \.outlookProperties.isSignificant)
                let sigWindOutlooks = windResponse?.filter(\.outlookProperties.isSignificant)
                let sigHailOutlooks = hailResponse?.filter(\.outlookProperties.isSignificant)
                let sigTornOutlooks = tornResponse?.filter(\.outlookProperties.isSignificant)
                
                guard let location = await WidgetLocation.shared.requestOneTimeLocation() else {
                    return makeTimeline(.error(.noLocation))
                }
                let findOutlook = { (feature: OutlookFeature) -> Bool in
                    feature.geometry.lazy.compactCast(to: MKMultiPolygon.self).contains { $0.contains(point: .init(location.coordinate)) }
                }
                let outlook = categoricalOutlooks.first(where: findOutlook)
                let windOutlook = windOutlooks?.first(where: findOutlook)
                let hailOutlook = hailOutlooks?.first(where: findOutlook)
                let tornOutlook = tornOutlooks?.first(where: findOutlook)
                let sigWind = sigWindOutlooks?.first(where: findOutlook) != nil
                let sigHail = sigHailOutlooks?.first(where: findOutlook) != nil
                let sigTorn = sigTornOutlooks?.first(where: findOutlook) != nil
                return makeTimeline(.outlook(.now, configuration.day, outlook, (
                    wind: (windOutlook?.outlookProperties.title ?? "No Wind Risk", sigWind),
                    hail: (hailOutlook?.outlookProperties.title ?? "No Hail Risk", sigHail),
                    tornado: (tornOutlook?.outlookProperties.title ?? "No Tornado Risk", sigTorn)
                )))
            } else {
                return makeTimeline(.error(.unknown))
            }
        }
    }
}
