//
//  CombinedConvectiveRiskFetcher.swift
//  Redzone
//
//  Created by Greg Whatley on 12/12/25.
//

import CoreLocation
import OSLog
import RedzoneCore

struct CombinedConvectiveRiskFetcher {
    private static let logger: Logger = .create()

    static func fetchCombinedConvectiveRisk(for day: CombinedConvectiveRiskProvider.Day, includeBreakdown: Bool) async -> Result<CombinedConvectiveRiskResult, WidgetError> {
        let locationService = await LocationService()
        guard let location = await locationService.requestLocation()?.coordinate else {
            logger.debug("Location services disabled.")
            return .failure(.locationDisabled)
        }

        let outlookService = OutlookService(adapter: .urlSession)
        let categoricalRisk: OutlookResponse
        do {
            categoricalRisk = try await outlookService.fetchOutlook(type: day.categoricalType)
        } catch {
            logger.debug("Failed to fetch categorical outlook.")
            return .failure(.fetchError)
        }
        guard let outlook = categoricalRisk.findOutlook(containing: location) else {
            logger.debug("No risk found.")
            return .failure(.noRisk)
        }

        if day.supportsOutlookBreakdown && includeBreakdown {
            guard outlook.highestRisk.properties.severity > .generalThunder,
                  let windType = day.windType,
                  let hailType = day.hailType,
                  let tornadoType = day.tornadoType else {
                logger.debug("Risk too low for breakdown or breakdown types not defined.")
                return .success(.init(
                    convective: .init(from: outlook),
                    discreteRisks: .init(wind: nil, hail: nil, tornado: nil, at: location)
                ))
            }

            async let wind = (try await outlookService.fetchOutlook(type: windType)).findOutlook(containing: location)
            async let hail = (try await outlookService.fetchOutlook(type: hailType)).findOutlook(containing: location)
            async let tornado = (try await outlookService.fetchOutlook(type: tornadoType)).findOutlook(containing: location)

            do {
                logger.debug("Building discrete risk breakdown...")
                return .success(.init(
                    convective: .init(from: outlook),
                    discreteRisks: .init(
                        wind: try await wind,
                        hail: try await hail,
                        tornado: try await tornado,
                        at: location
                    )
                ))
            } catch {
                logger.debug("Discrete risk request failed.")
                return .failure(.fetchError)
            }
        } else {
            logger.debug("Outlook breakdown not requested or not supported.")
            return .success(.init(convective: .init(from: outlook), discreteRisks: nil))
        }
    }
}
