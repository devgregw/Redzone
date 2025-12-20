//
//  OutlookType.swift
//  RedzoneCore
//
//  Created by Greg Whatley on 9/20/25.
//

import Foundation
import OSLog
internal import RedzoneMacros

public enum OutlookType: Codable, Hashable, Sendable {
    public enum Convective: Codable, Hashable, Sendable {
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
    }

    case convective(_: Convective)

    public var commentaryURL: URL {
        switch self {
        case let .convective(convective):
            #URL("day\(convective.day)otlk.html", relativeTo: #URL("https://www.spc.noaa.gov/products/outlook/"))
        }
    }

    public var pathSegments: [String] {
        switch self {
        case let .convective(value): ["convective"] + value.pathSegments
        }
    }
}
