//
//  OutlookProvider.swift
//  SPCMapWidgets
//
//  Created by Greg Whatley on 8/20/24.
//

import WidgetKit
import GeoJSON

struct OutlookProvider: WidgetFoundation.Provider, AppIntentTimelineProvider {
    typealias Intent = OutlookDayConfigurationIntent
    
    struct EntryData: WidgetFoundation.EntryData {
        static let preview: Self = .init(date: .now, day: .day1, title: "Enhanced Risk", value: 3.0, risks: .init(wind: .init(percentage: 30, isSignificant: true), hail: .init(percentage: 15, isSignificant: false), tornado: .init(percentage: 2, isSignificant: false)))
        static let none: Self = .init(date: .now, day: .day1, title: nil, value: nil, risks: .none)
        
        let date: Date
        let day: OutlookDay
        let title: String?
        let value: Double?
        let risks: CombinedRisks
        var url: CommonURL? { .setOutlook(to: day) }
    }
    
    func getOutlook(day: OutlookDay, type: OutlookType.ConvectiveOutlookType) async -> [GeoJSONFeature]? {
        return switch await OutlookFetcher.fetch(outlook: day == .day1 ? .convective1(type) : .convective2(type)) {
        case .success(let response): response.features.sorted().reversed()
        default: nil
        }
    }
    
    func timeline(for configuration: OutlookDayConfigurationIntent, in context: Context) async -> Timeline<Entry> {
        guard let location = await WidgetLocation.requestLocation() else {
            return .init(entry: .error(.noLocation), policy: .after(hours: 2))
        }
        
        if let categoricalResponse = await getOutlook(day: configuration.day, type: .categorical) {
            let categoricalOutlook = categoricalResponse.lazy.filter(\.outlookProperties.isSignificant.not).first(at: location.coordinate)
            
            if context.family == .systemSmall {
                return .init(entry: .success(.init(
                    date: .now,
                    day: configuration.day,
                    title: categoricalOutlook?.outlookProperties.title,
                    value: categoricalOutlook?.outlookProperties.severity.comparableValue,
                    risks: .none
                )), policy: .after(hours: 2))
            }
            
            let windResponse = await self.getOutlook(day: configuration.day, type: .wind)
            let hailResponse = await self.getOutlook(day: configuration.day, type: .hail)
            let tornResponse = await self.getOutlook(day: configuration.day, type: .tornado)
            
            let windOutlooks = windResponse?.split(on: \.outlookProperties.isSignificant)
            let hailOutlooks = hailResponse?.split(on: \.outlookProperties.isSignificant)
            let tornOutlooks = tornResponse?.split(on: \.outlookProperties.isSignificant)
            
            let windOutlook = windOutlooks?.false.first(at: location.coordinate)
            let hailOutlook = hailOutlooks?.false.first(at: location.coordinate)
            let tornOutlook = tornOutlooks?.false.first(at: location.coordinate)
            let sigWind = windOutlooks?.true.first(at: location.coordinate)
            let sigHail = hailOutlooks?.true.first(at: location.coordinate)
            let sigTorn = tornOutlooks?.true.first(at: location.coordinate)
            return .init(entry: .success(.init(
                date: .now,
                day: configuration.day,
                title: categoricalOutlook?.outlookProperties.title,
                value: categoricalOutlook?.outlookProperties.severity.comparableValue,
                risks: .init(
                    wind: .init(feature: windOutlook, significantFeature: sigWind),
                    hail: .init(feature: hailOutlook, significantFeature: sigHail),
                    tornado: .init(feature: tornOutlook, significantFeature: sigTorn)
                )
            )), policy: .after(hours: 2))
        } else {
            return .init(entry: .error(.unknown), policy: .after(hours: 2))
        }
    }
}
