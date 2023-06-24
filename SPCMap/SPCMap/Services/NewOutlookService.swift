//
//  NewOutlookService.swift
//  SPC
//
//  Created by Greg Whatley on 4/2/23.
//

import CoreLocation
import SwiftUI
import SPCCommon

enum OutlookType2: Hashable {
    enum ConvectiveOutlookType: String {
        case categorical = "cat"
        case wind = "wind"
        case hail = "hail"
        case tornado = "torn"
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
    
    var path: String {
        switch self {
        case .convective1(let type), .convective2(let type), .convective3(let type): "convective/\(day)/\(type.rawValue)"
        case .convective4, .convective5, .convective6, .convective7, .convective8: "convective/\(day)"
        }
    }
}

class NewOutlookService: ObservableObject {
    enum State {
        case noData
        case loading
        case loaded(response: OutlookResponse2)
        case error(error: String)
    }
    
    private let hostname = "http://192.168.100.9:8080"
    
    @Published var state: State = .noData
    
    @MainActor func load(_ type: OutlookType2) async {
        if let url = URL(string: "\(hostname)/\(type.path)") {
            do {
                self.state = .loading
                let data = try await URLSession.shared.data(from: url).0
                let response = try OutlookResponse2(data: data, outlookType: type)
                self.state = .loaded(response: response)
            } catch {
                debugPrint(error.localizedDescription)
                self.state = .error(error: error.localizedDescription)
            }
        } else {
            self.state = .error(error: "Invalid selection specified")
        }
    }
    
    func loadTask(_ type: OutlookType2) {
        Task {
            await load(type)
        }
    }
}
