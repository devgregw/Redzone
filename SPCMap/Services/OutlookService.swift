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
            case .categorical: "square.stack.3d.down.forward"
            case .wind: "wind"
            case .hail: "cloud.hail"
            case .tornado: "tornado"
            }
        }
        
        var displayName: String {
            switch self {
            case .categorical: "Categorical"
            case .tornado: "Tornado"
            default: rawValue.capitalized
            }
        }
    }
    
    case convective1(_: ConvectiveOutlookType)
    case convective2(_: ConvectiveOutlookType)
    case convective3(_: ConvectiveOutlookType)
    
    case convective4
    case convective5
    case convective6
    case convective7
    case convective8
    
    var day: Int {
        switch self {
        case .convective1: 1
        case .convective2: 2
        case .convective3: 3
        case .convective4: 4
        case .convective5: 5
        case .convective6: 6
        case .convective7: 7
        case .convective8: 8
        }
    }
    
    var isConvective: Bool {
        true
    }
    
    var subSection: String {
        switch self {
        case .convective1(let type), .convective2(let type), .convective3(let type): type.displayName
        case .convective4, .convective5, .convective6, .convective7, .convective8: "Probabilistic"
        }
    }
    
    var category: String {
        "Convective"
    }
    
    var path: String {
        switch self {
        case .convective1(let type), .convective2(let type), .convective3(let type): "convective/\(day)/\(type.rawValue)"
        case .convective4, .convective5, .convective6, .convective7, .convective8: "convective/\(day)"
        }
    }
    
    var convectiveSubtype: ConvectiveOutlookType? {
        switch self {
        case let .convective1(subtype), let .convective2(subtype), let .convective3(subtype): subtype
        default: nil
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(path)
    }
}

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
    
    private let hostname = "http://192.168.100.9:8080"
    
    @Published var state: State = .loading
    
    @MainActor func load(_ type: OutlookType) async {
        if let url = URL(string: "\(hostname)/\(type.path)") {
            do {
                self.state = .loading
                let data = try await URLSession.shared.data(from: url).0
                let response = try OutlookResponse(data: data, outlookType: type)
                if response.features.count <= 1 || (response.features.first?.geometry.isEmpty ?? true) {
                    self.state = .noData
                } else {
                    self.state = .loaded(response: response)
                }
            } catch {
                debugPrint(error.localizedDescription)
                self.state = .error(error: error.localizedDescription)
            }
        } else {
            self.state = .error(error: "Invalid selection specified")
        }
    }
}
