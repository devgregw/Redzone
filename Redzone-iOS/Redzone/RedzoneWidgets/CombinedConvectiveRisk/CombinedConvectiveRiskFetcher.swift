//
//  CombinedConvectiveRiskFetcher.swift
//  Redzone
//
//  Created by Greg Whatley on 12/12/25.
//

import CoreLocation
import FirebaseAppCheck
import FirebaseCore
import OSLog
import RedzoneCore

struct CombinedConvectiveRiskFetcher {
    private static let logger: Logger = .create()

    static func fetchCombinedConvectiveRisk(
        for day: CombinedConvectiveRiskProvider.Day,
        includeBreakdown: Bool
    ) async -> Result<CombinedConvectiveRiskResult, WidgetError> {
        let locationService = await LocationService(persistLastKnownLocation: true)
        guard let location = await locationService.requestLocation()?.coordinate else {
            logger.debug("Location services disabled.")
            return .failure(.locationDisabled)
        }

        let outlookService = OutlookService(adapter: .urlSession {
            if FirebaseApp.app() == nil {
#if targetEnvironment(simulator)
                AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())
#endif
                FirebaseApp.configure()
            }
            return try await AppCheck.appCheck().token(forcingRefresh: false).token
        })
        let categoricalRisk: OutlookCollection
        do {
            categoricalRisk = try await outlookService.fetchOutlook(type: day.categoricalType)
        } catch {
            logger.debug("Failed to fetch categorical outlook.")
            return .failure(.fetchError)
        }
        guard let outlook = categoricalRisk.findRisks(at: location),
              let primary = outlook[.convectivePrimary] else {
            logger.debug("No risk found.")
            return .failure(.noRisk)
        }

        if day.supportsOutlookBreakdown && includeBreakdown {
            guard primary.properties.severity > .generalThunder,
                  let windType = day.windType,
                  let hailType = day.hailType,
                  let tornadoType = day.tornadoType else {
                logger.debug("Risk too low for breakdown or breakdown types not defined.")
                return .success(.init(
                    convective: .init(from: primary),
                    discreteRisks: .init(wind: nil, hail: nil, tornado: nil, at: location)
                ))
            }

            async let wind = (try await outlookService.fetchOutlook(type: windType)).findRisks(at: location)
            async let hail = (try await outlookService.fetchOutlook(type: hailType)).findRisks(at: location)
            async let tornado = (try await outlookService.fetchOutlook(type: tornadoType)).findRisks(at: location)

            do {
                logger.debug("Building discrete risk breakdown...")
                return .success(.init(
                    convective: .init(from: primary),
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
            return .success(.init(convective: .init(from: primary), discreteRisks: nil))
        }
    }
}
