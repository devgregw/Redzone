//
//  OutlookSeverity.swift
//  SPC
//
//  Created by Greg Whatley on 4/7/23.
//

import Foundation

public enum OutlookSeverity: String, Comparable, Equatable {
    public static func < (lhs: OutlookSeverity, rhs: OutlookSeverity) -> Bool {
        lhs.comparableValue < rhs.comparableValue
    }
    
    case generalThunder = "TSTM"
    case marginal = "MRGL"
    case slight = "SLGT"
    case enhanced = "ENH"
    case moderate = "MDT"
    case high = "HIGH"
    case significant = "SIGN"
    case probabilistic = "PROB"
    case sigprobabilistic = "SIGPROB"
    
    public var comparableValue: Int {
        switch self {
        case .significant, .probabilistic, .sigprobabilistic: return 0
        case .high: return 1
        case .moderate: return 2
        case .enhanced: return 3
        case .slight: return 4
        case .marginal: return 5
        case .generalThunder: return 6
        }
    }
}
