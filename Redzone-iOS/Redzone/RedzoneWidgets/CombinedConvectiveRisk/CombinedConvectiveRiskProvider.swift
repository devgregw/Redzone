//
//  CombinedConvectiveRiskProvider.swift
//  Redzone
//
//  Created by Greg Whatley on 12/12/25.
//

import AppIntents
import CoreLocation
import OSLog
import RedzoneCore
import WidgetKit

struct CombinedConvectiveRiskProvider: AppIntentTimelineProvider {
    private static let logger: Logger = .create()

    enum Day: Int, AppEnum {
        case dayOne = 1
        case dayTwo
        case dayThree

        static let typeDisplayRepresentation: TypeDisplayRepresentation = "Outlook Day"
        static let caseDisplayRepresentations: [Day: DisplayRepresentation] = [
            .dayOne: "Today",
            .dayTwo: "Tomorrow",
            .dayThree: "Day after tomorrow"
        ]

        var supportsOutlookBreakdown: Bool {
            self != .dayThree
        }

        var categoricalType: OutlookType {
            switch self {
            case .dayOne: .convective(.day1(.categorical))
            case .dayTwo: .convective(.day2(.categorical))
            case .dayThree: .convective(.day3(probabilistic: false))
            }
        }

        var windType: OutlookType? {
            switch self {
            case .dayOne: .convective(.day1(.wind))
            case .dayTwo: .convective(.day2(.wind))
            case .dayThree: nil
            }
        }

        var hailType: OutlookType? {
            switch self {
            case .dayOne: .convective(.day1(.hail))
            case .dayTwo: .convective(.day2(.hail))
            case .dayThree: nil
            }
        }

        var tornadoType: OutlookType? {
            switch self {
            case .dayOne: .convective(.day1(.tornado))
            case .dayTwo: .convective(.day2(.tornado))
            case .dayThree: nil
            }
        }
    }

    struct Entry: TimelineEntry {
        let date: Date = .now
        let day: Day
        let result: Result<CombinedConvectiveRiskResult, WidgetError>
    }

    struct Configuration: WidgetConfigurationIntent {
        public static let title: LocalizedStringResource = "outlookDayConfigurationTitle"
        public static let description = IntentDescription(LocalizedStringResource(stringLiteral: "outlookDayConfigurationDesc"))

        @Parameter(title: "Outlook Day", default: .dayOne)
        var day: Day

        public init(day: Day) {
            self.day = day
        }

        init() { }
    }

    typealias Intent = Configuration

    func placeholder(in context: Context) -> Entry {
        Self.logger.debug("Placeholder requested: \(context.family.description).")
        return .init(day: .dayOne, result: .failure(.placeholder))
    }

    func snapshot(for configuration: Intent, in context: Context) async -> Entry {
        Self.logger.debug("Snapshot for day \(configuration.day.rawValue) requested: \(context.family.description) (preview: \(context.isPreview)).")
        return if context.isPreview {
            .init(day: configuration.day, result: .success(.placeholder))
        } else {
            await fetchEntry(configuration: configuration, context: context)
        }
    }

    func timeline(for configuration: Intent, in context: Context) async -> Timeline<Entry> {
        Self.logger.debug("Timeline for day \(configuration.day.rawValue) requested: \(context.family.description) (preview: \(context.isPreview)).")
        return .init(
            entries: [await fetchEntry(configuration: configuration, context: context)],
            policy: .after(.now.addingTimeInterval(7200))
        )
    }

    private func fetchEntry(configuration: Intent, context: Context) async -> Entry {
        .init(
            day: configuration.day,
            result: await CombinedConvectiveRiskFetcher.fetchCombinedConvectiveRisk(
                for: configuration.day,
                includeBreakdown: context.family == .systemMedium || context.family == .accessoryRectangular
            )
        )
    }
}
