//
//  OutlookType.swift
//  RedzoneCore
//
//  Created by Greg Whatley on 9/20/25.
//

import Foundation
import OSLog
internal import RedzoneMacros

public enum OutlookType: RawRepresentable, Codable, Hashable, Sendable {

    case convective(_: Convective)
    case fire(_: Fire)

    public var commentaryURL: URL {
        switch self {
        case let .convective(convective):
            #URL("day\(convective.day)otlk.html", relativeTo: #URL("https://www.spc.noaa.gov/products/outlook/"))
        case let .fire(fire):
            #URL("fwdy\(fire.day).html", relativeTo: #URL("https://www.spc.noaa.gov/products/fire_wx/"))
        }
    }

    public var pathSegments: [String] {
        switch self {
        case let .convective(value): ["convective"] + value.pathSegments
        case let .fire(fire): ["fire"] + fire.pathSegments
        }
    }

    public var rawValue: [String] { pathSegments }

    public init?(rawValue: [String]) {
        switch rawValue.first {
        case "convective":
            if let convective = Convective(rawValue: Array(rawValue.dropFirst())) {
                self = .convective(convective)
                return
            }
        case "fire":
            if let fire = Fire(rawValue: Array(rawValue.dropFirst())) {
                self = .fire(fire)
                return
            }
        default: break
        }
        return nil
    }
}

public enum Fire: RawRepresentable, Codable, Hashable, Sendable {
    case day1
    case day2

    public var day: Int {
        switch self {
        case .day1: 1
        case .day2: 2
        }
    }

    public var pathSegments: [String] { [String(day)] }

    public var rawValue: [String] { pathSegments }

    public init?(rawValue: [String]) {
        guard let dayStr = rawValue.first,
              let day = Int(dayStr) else { return nil }
        switch day {
        case 1: self = .day1
        case 2: self = .day2
        default: return nil
        }
    }
}

public enum Convective: RawRepresentable, Codable, Hashable, Sendable {
    public enum Classification: String, Codable, Hashable, Sendable {
        case categorical = "cat"
        case wind = "wind"
        case hail = "hail"
        case tornado = "torn"
    }

    case day1(_: Classification)
    case day2(_: Classification)
    case day3(probabilistic: Bool)
    case day4
    case day5
    case day6
    case day7
    case day8

    public var day: Int {
        switch self {
        case .day1: 1
        case .day2: 2
        case .day3: 3
        case .day4: 4
        case .day5: 5
        case .day6: 6
        case .day7: 7
        case .day8: 8
        }
    }

    public var isProbabilistic: Bool {
        switch self {
        case .day3(probabilistic: true), .day4, .day5, .day6, .day7, .day8: true
        default: false
        }
    }

    public var isCategorical: Bool {
        switch self {
        case let .day1(classification), let .day2(classification): classification == .categorical
        case .day3(probabilistic: false): true
        default: false
        }
    }

    var pathSegments: [String] {
        switch self {
        case let .day1(classification), let .day2(classification):
            [String(day), classification.rawValue]
        case .day3(probabilistic: false):
            [String(day), Classification.categorical.rawValue]
        case .day3(probabilistic: true), .day4, .day5, .day6, .day7, .day8:
            [String(day), "prob"]
        }
    }

    public var rawValue: [String] { pathSegments }

    // swiftlint:disable:next cyclomatic_complexity
    public init?(rawValue: [String]) {
        guard let dayStr = rawValue.first,
              let classification = rawValue.last,
              let day = Int(dayStr) else { return nil }
        switch day {
        case 1:
            if let classification = Classification(rawValue: classification) {
                self = .day1(classification)
                return
            }
        case 2:
            if let classification = Classification(rawValue: classification) {
                self = .day2(classification)
                return
            }
        case 3 where classification == Classification.categorical.rawValue:
            self = .day3(probabilistic: false)
            return
        case 3 where classification == "prob":
            self = .day3(probabilistic: true)
            return
        case 4: self = .day4
        case 5: self = .day5
        case 6: self = .day6
        case 7: self = .day7
        case 8: self = .day8
        default: break
        }
        return nil
    }
}
