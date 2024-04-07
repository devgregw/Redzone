//
//  OutlookSeverity.swift
//  SPCMap
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
            self = .unknown
        }
    }
    
    public var comparableValue: Double {
        switch self {
        case let .percentage(value): value
        case .significant, .probabilistic, .sigprobabilistic: 10
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
