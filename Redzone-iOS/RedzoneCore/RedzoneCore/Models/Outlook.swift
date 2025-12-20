//
//  Outlook.swift
//  RedzoneCore
//
//  Created by Greg Whatley on 9/21/25.
//

import CoreLocation
import Foundation
import GeoJSON

public struct Outlook: Sendable, Hashable, Identifiable {
    public enum Severity: Sendable, Hashable, Comparable {
        public static func < (lhs: Severity, rhs: Severity) -> Bool {
            lhs.comparableValue < rhs.comparableValue
        }

        private static let idMapping: [String: Severity] = [
            "TSTM": .generalThunder,
            "MRGL": .marginal,
            "SLGT": .slight,
            "ENH": .enhanced,
            "MDT": .moderate,
            "HIGH": .high,
            "SIGN": .significant,
            "SIGPROB": .sigprobabilistic
        ]

        case generalThunder
        case marginal
        case slight
        case enhanced
        case moderate
        case high
        case significant
        case sigprobabilistic
        case percentage(Double)
        case unknown

        init(rawValue: String) {
            if let percentage = Double(rawValue) {
                self = .percentage(percentage)
            } else if let mappedValue = Severity.idMapping[rawValue] {
                self = mappedValue
            } else {
                self = .unknown
            }
        }

        public var comparableValue: Double {
            switch self {
            case let .percentage(value): value
            case .significant, .sigprobabilistic: 10
            case .generalThunder: 0
            case .marginal: 1
            case .slight: 2
            case .enhanced: 3
            case .moderate: 4
            case .high: 5
            case .unknown: -1
            }
        }
    }

    public struct Properties: Sendable, Hashable, Identifiable {
        public let id: String
        public let title: String
        public let fillColor: String
        public let strokeColor: String
        public let severity: Severity
        public let expire: Date?
        public let valid: Date?
        public let issue: Date?

        private static func makeDate(from value: String) -> Date? {
            guard let year = Int(value.prefix(4)),
                  let month = Int(value.dropFirst(4).prefix(2)),
                  let day = Int(value.dropFirst(6).prefix(2)),
                  let hour = Int(value.dropFirst(8).prefix(2)),
                  let minute = Int(value.dropFirst(10).prefix(2))
            else { return nil }

            var components = DateComponents()
            components.calendar = .init(identifier: .gregorian)
            components.timeZone = .gmt
            components.year = year
            components.month = month
            components.day = day
            components.hour = hour
            components.minute = minute

            return components.date
        }

        public init(from feature: GeoJSONFeature) {
            self.init(
                id: feature.properties["LABEL"] ?? "",
                title: feature.properties["LABEL2"] ?? "",
                fillColor: feature.properties["fill"] ?? "",
                strokeColor: feature.properties["stroke"] ?? "",
                expire: feature.properties["EXPIRE"] ?? "",
                valid: feature.properties["VALID"] ?? "",
                issue: feature.properties["ISSUE"] ?? ""
            )
        }

        public init(id: String, title: String, fillColor: String, strokeColor: String, expire: String, valid: String, issue: String) {
            self.id = id
            self.title = title
            self.fillColor = fillColor
            self.strokeColor = strokeColor
            self.expire = Self.makeDate(from: expire)
            self.valid = Self.makeDate(from: valid)
            self.issue = Self.makeDate(from: issue)
            self.severity = .init(rawValue: id)
        }
    }

    public let outlookType: OutlookType
    public let highestRisk: OutlookResponse.Feature
    public let significantFeature: OutlookResponse.Feature?

    public func riskIncludes(location: CLLocationCoordinate2D) -> Bool {
        highestRisk.multiPolygon.contains(.init(coordinate: location))
    }

    public func isSignificantAt(location: CLLocationCoordinate2D) -> Bool {
        significantFeature?.multiPolygon.contains(.init(coordinate: location)) ?? false
    }

    init(wrapping highestRisk: OutlookResponse.Feature, significantFeature: OutlookResponse.Feature?, type: OutlookType) {
        self.highestRisk = highestRisk
        self.significantFeature = significantFeature
        self.outlookType = type
    }

    public var id: Int {
        [highestRisk.id, significantFeature?.id].hashValue
    }
}
