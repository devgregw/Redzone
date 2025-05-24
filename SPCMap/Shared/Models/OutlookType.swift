//
//  OutlookType.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/6/24.
//

import Foundation

enum OutlookType: Hashable, Sendable {
    enum ConvectiveOutlookType: String {
        case categorical = "cat"
        case wind = "wind"
        case hail = "hail"
        case tornado = "torn"
        
        var systemImage: String {
            switch self {
            case .categorical: return "square.stack.3d.down.forward"
            case .wind: return "wind"
            case .hail: return "cloud.hail"
            case .tornado: return "tornado"
            }
        }
        
        var displayName: String {
            switch self {
            case .categorical: return "Categorical"
            case .tornado: return "Tornado"
            default: return rawValue.capitalized
            }
        }
    }
    
    case convective1(_: ConvectiveOutlookType)
    case convective2(_: ConvectiveOutlookType)
    case convective3(probabilistic: Bool)
    
    case convective4
    case convective5
    case convective6
    case convective7
    case convective8
    
    var day: Int {
        switch self {
        case .convective1: return 1
        case .convective2: return 2
        case .convective3: return 3
        case .convective4: return 4
        case .convective5: return 5
        case .convective6: return 6
        case .convective7: return 7
        case .convective8: return 8
        }
    }
    
    var isConvective: Bool {
        true
    }
    
    var isProbabilistic: Bool {
        if case let .convective3(probabilistic) = self {
            return probabilistic
        } else {
            return day >= 4
        }
    }
    
    var subSection: String {
        switch self {
        case .convective1(let type), .convective2(let type): return type.displayName
        case .convective3(let probabilistic): return probabilistic ? "Probabilistic" : ConvectiveOutlookType.categorical.displayName
        case .convective4, .convective5, .convective6, .convective7, .convective8: return "Probabilistic"
        }
    }
    
    var category: String {
        "Convective"
    }
    
    var path: String {
        switch self {
        case .convective1(let type), .convective2(let type): return "convective/\(day)/\(type.rawValue)"
        case .convective3(let probabilistic): return "convective/\(day)/\(probabilistic ? "prob" : ConvectiveOutlookType.categorical.rawValue)"
        case .convective4, .convective5, .convective6, .convective7, .convective8: return "convective/\(day)/prob"
        }
    }
    
    var convectiveSubtype: ConvectiveOutlookType? {
        switch self {
        case let .convective1(subtype), let .convective2(subtype): return subtype
        case let .convective3(probabilistic): return probabilistic ? nil : ConvectiveOutlookType.categorical
        default: return nil
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(path)
    }
}
