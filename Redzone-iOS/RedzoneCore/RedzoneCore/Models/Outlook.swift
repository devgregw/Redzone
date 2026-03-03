//
//  Outlook.swift
//  RedzoneCore
//
//  Created by Greg Whatley on 9/21/25.
//

import CoreLocation
import Foundation
import GeoJSON

public enum OutlookSeverity: Sendable, Hashable, Comparable {
    public static func < (lhs: OutlookSeverity, rhs: OutlookSeverity) -> Bool {
        lhs.comparableValue < rhs.comparableValue
    }

    private static let idMapping: [String: OutlookSeverity] = [
        "TSTM": .generalThunder,
        "MRGL": .marginal,
        "SLGT": .slight,
        "ENH": .enhanced,
        "MDT": .moderate,
        "HIGH": .high,
        "CIG1": .cig1,
        "CIG2": .cig2,
        "CIG3": .cig3,
        "SIGN": .significant,
        "SIGPROB": .sigprobabilistic,
        "ELEV": .fireElevated,
        "CRIT": .fireCritical,
        "EXTM": .fireExtreme
    ]

    case generalThunder
    case marginal
    case slight
    case enhanced
    case moderate
    case high
    case significant
    case sigprobabilistic
    case cig1
    case cig2
    case cig3
    case fireElevated
    case fireCritical
    case fireExtreme
    case percentage(Double)
    case unknown

    init(rawValue: String) {
        if let percentage = Double(rawValue) {
            self = .percentage(percentage)
        } else if let mappedValue = OutlookSeverity.idMapping[rawValue] {
            self = mappedValue
        } else {
            self = .unknown
        }
    }

    public var isCIG: Bool {
        self == .cig1 || self == .cig2 || self == .cig3
    }

    public var comparableValue: Double {
        switch self {
        case let .percentage(value): value
        case .cig3: 12
        case .cig2: 11
        case .significant, .sigprobabilistic, .cig1: 10
        case .generalThunder: 0
        case .marginal, .fireElevated: 1
        case .slight: 2
        case .enhanced, .fireCritical: 3
        case .moderate: 4
        case .high, .fireExtreme: 5
        case .unknown: -1
        }
    }
}

public struct OutlookProperties: Sendable, Hashable, Identifiable {
    public let id: String
    public let title: String
    public let fillColor: String
    public let strokeColor: String
    public let severity: OutlookSeverity
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
            id: feature.properties["LABEL"]?.stringValue ?? "",
            title: feature.properties["LABEL2"]?.stringValue ?? "",
            fillColor: feature.properties["fill"]?.stringValue ?? "",
            strokeColor: feature.properties["stroke"]?.stringValue ?? "",
            expire: feature.properties["EXPIRE"]?.stringValue ?? "",
            valid: feature.properties["VALID"]?.stringValue ?? "",
            issue: feature.properties["ISSUE"]?.stringValue ?? ""
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

public struct OutlookCollection: Decodable, Sendable, Hashable {
    public enum Identifier: String, Sendable, Hashable, Comparable {
        case convectivePrimary
        case convectiveCIG
        case fireWindRH
        case fireDryTs

        private var comparableValue: Int {
            switch self {
            case .convectivePrimary, .fireWindRH: 0
            case .convectiveCIG, .fireDryTs: 1
            }
        }

        public static func < (lhs: Identifier, rhs: Identifier) -> Bool {
            lhs.comparableValue < rhs.comparableValue
        }
    }

    public let groups: [Identifier: [OutlookFeature]]

    enum CodingKeys: CodingKey {
        case groups
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.groups = Dictionary(
            uniqueKeysWithValues: (try container.decode([String: GeoJSONObject].self, forKey: .groups))
                .compactMap {
                    guard let id = Identifier(rawValue: $0.key),
                          let features = $0.value.features else { return nil }
                    return (
                        id,
                        features
                            .compactMap { OutlookFeature(feature: $0) }
                            .sorted { $0.properties.severity.comparableValue < $1.properties.severity.comparableValue }
                    )
                }
        )
    }

    public func findRisks(at location: CLLocationCoordinate2D) -> ResolvedOutlook? {
        let foundOutlooks = groups.compactMapValues {
            $0.reversed().first { $0.contains(location) }
        }
        guard !foundOutlooks.isEmpty else { return nil }
        return foundOutlooks
    }
}

public typealias ResolvedOutlook = [OutlookCollection.Identifier: OutlookFeature]
