//
//  OutlookSeverity.swift
//  SPC
//
//  Created by Greg Whatley on 4/7/23.
//

import Foundation

enum OutlookSeverity: Comparable, Equatable {
    static func < (lhs: OutlookSeverity, rhs: OutlookSeverity) -> Bool {
        lhs.comparableValue < rhs.comparableValue
    }
    
    private static let idMapping: [String: OutlookSeverity] = [
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
    case probabilistic
    case sigprobabilistic
    case percentage(Double)
    case unknown
    
    init(rawValue: String) {
        if let percentage = Double(rawValue) {
            self = .percentage(percentage)
        } else if let mappedValue = OutlookSeverity.idMapping[rawValue] {
            self = mappedValue
        } else {
            debugPrint("Warning: raw value \(rawValue) for OutlookSeverity could not be mapped to a known case.")
            self = .unknown
        }
    }
    
    public var comparableValue: Double {
        switch self {
        case let .percentage(value): value
        case .significant, .probabilistic, .sigprobabilistic: 10
        case .generalThunder: 1
        case .marginal: 2
        case .slight: 3
        case .enhanced: 4
        case .moderate: 5
        case .high: 6
        case .unknown: -1
        }
    }
}
