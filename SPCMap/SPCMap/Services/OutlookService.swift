//
//  NewOutlookService.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/2/23.
//

import CoreLocation
import SwiftUI

enum OutlookType: Hashable {
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
        case .convective4, .convective5, .convective6, .convective7, .convective8: return "convective/\(day)"
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

@Observable
class OutlookService: ObservableObject {
    enum State: Hashable {
        case noData
        case loading
        case loaded(response: OutlookResponse)
        case error(error: String)
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .noData: hasher.combine("noData")
            case .loading: hasher.combine("loading")
            case .error(let error): hasher.combine(error)
            case .loaded(let response): hasher.combine(response)
            }
        }
        
        static func == (lhs: OutlookService.State, rhs: OutlookService.State) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
    }
    
    private let hostname = "http://192.168.100.9:8081"
    
    var state: State = .loading
    private var lastOutlookType: OutlookType = Context.defaultOutlookType
    
    @MainActor func load(_ type: OutlookType) async {
        lastOutlookType = type
        if let url = URL(string: "\(hostname)/\(type.path)") {
            do {
                self.state = .loading
                let (data, urlResponse) = try await URLSession.shared.data(from: url)
                if let httpResponse = urlResponse as? HTTPURLResponse,
                   httpResponse.statusCode == 204 {
                    self.state = .noData
                } else {
                    let response = try OutlookResponse(data: data, outlookType: type)
                    if response.features.first?.geometry.isEmpty ?? true {
                        self.state = .noData
                    } else {
                        self.state = .loaded(response: response)
                    }
                }
            } catch {
                self.state = .error(error: error.localizedDescription)
            }
        } else {
            self.state = .error(error: "Invalid selection specified")
        }
    }
    
    @MainActor func refresh() async {
        await load(lastOutlookType)
    }
}
