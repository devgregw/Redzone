//
//  RedzoneCore.swift
//  RedzoneUI
//
//  Created by Greg Whatley on 9/30/25.
//

import Foundation
import RedzoneCore

extension OutlookType: @retroactive CustomStringConvertible, @retroactive CustomLocalizedStringResourceConvertible {
    public var localizedStringResource: LocalizedStringResource {
        switch self {
        case let .convective(value): value.localizedStringResource
        case let .fire(value): value.localizedStringResource
        @unknown default: LocalizedStringResource(stringLiteral: String(describing: self))
        }
    }
}

extension Convective: @retroactive CustomStringConvertible, @retroactive CustomLocalizedStringResourceConvertible {
    public var localizedStringResource: LocalizedStringResource {
        switch self {
        case let .day1(classification), let .day2(classification): .convectiveDescription(label: classification.description, day: day)
        case .day3(probabilistic: false): .convectiveDescription(label: Classification.categorical.description, day: day)
        case .day3(probabilistic: true), .day4, .day5, .day6, .day7, .day8: .convectiveDescription(label: String(localized: .probabilistic), day: day)
        @unknown default: LocalizedStringResource(stringLiteral: String(describing: self))
        }
    }
}

extension Fire: @retroactive CustomStringConvertible, @retroactive CustomLocalizedStringResourceConvertible {
    public var localizedStringResource: LocalizedStringResource {
        switch self {
        case .day1: .convectiveDescription(label: "Fire", day: 1)
        case .day2: .convectiveDescription(label: "Fire", day: 2)
        @unknown default: LocalizedStringResource(stringLiteral: String(describing: self))
        }
    }
}

extension Convective.Classification: @retroactive CustomStringConvertible, @retroactive CustomLocalizedStringResourceConvertible {
    public var localizedStringResource: LocalizedStringResource {
        switch self {
        case .categorical: .categorical
        case .wind: .wind
        case .hail: .hail
        case .tornado: .tornado
        @unknown default: LocalizedStringResource(stringLiteral: String(describing: self))
        }
    }
}
