//
//  CombinedConvectiveRiskResult.swift
//  Redzone
//
//  Created by Greg Whatley on 12/12/25.
//

import CoreLocation
import RedzoneCore

struct CombinedConvectiveRiskResult: Equatable {
    let convective: ConvectiveRisk
    let discreteRisks: DiscreteRisks?

    static let placeholder: CombinedConvectiveRiskResult = .init(convective: .placeholder, discreteRisks: .placeholder)
}

struct ConvectiveRisk: Equatable {
    let value: String
    let title: String

    init(from feature: OutlookFeature) {
        self.value = feature.properties.id
        self.title = feature.properties.title
    }

    private init(value: String, title: String) {
        self.value = value
        self.title = title
    }

    static let placeholder: ConvectiveRisk = .init(value: "ENH", title: "Enhanced Risk")
}

struct DiscreteRisks: Equatable {
    typealias RiskValue = (value: Int, sig: Bool)
    let wind: RiskValue?
    let hail: RiskValue?
    let tornado: RiskValue?

    static func == (lhs: DiscreteRisks, rhs: DiscreteRisks) -> Bool {
        lhs.wind?.value == rhs.wind?.value && lhs.wind?.sig == rhs.wind?.sig &&
        lhs.hail?.value == rhs.hail?.value && lhs.hail?.sig == rhs.hail?.sig &&
        lhs.tornado?.value == rhs.tornado?.value && lhs.tornado?.sig == rhs.tornado?.sig
    }

    private static func makeRisk(from outlook: ResolvedOutlook?, at location: CLLocationCoordinate2D) -> RiskValue? {
        guard let feature = outlook?[.convectivePrimary] else { return nil }
        let containsCIG = outlook?[.convectiveCIG] != nil
        return (value: Int(feature.properties.severity.comparableValue * 100), sig: containsCIG)
    }

    init(wind: ResolvedOutlook?, hail: ResolvedOutlook?, tornado: ResolvedOutlook?, at location: CLLocationCoordinate2D) {
        self.wind = Self.makeRisk(from: wind, at: location)
        self.hail = Self.makeRisk(from: hail, at: location)
        self.tornado = Self.makeRisk(from: tornado, at: location)
    }

    private init(wind: RiskValue?, hail: RiskValue?, tornado: RiskValue?) {
        self.wind = wind
        self.hail = hail
        self.tornado = tornado
    }

    static let placeholder: DiscreteRisks = .init(wind: (30, true), hail: (5, false), tornado: nil)
}
