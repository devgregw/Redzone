//
//  NewOutlookService.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/2/23.
//

import Combine
import SwiftUI

@Observable
class OutlookService {
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
        
        init(fetcherResult: Result<OutlookResponse, OutlookFetcherError>) {
            self = switch fetcherResult {
            case .success(let response): .loaded(response: response)
            case .failure(let underlying):
                switch underlying {
                case .noData: .noData
                case .networkError(let cause): .error(error: cause.localizedDescription)
                case .unknown(let message): .error(error: message)
                }
            }
        }
    }
    
    @ObservationIgnored private let stateChangePublisher = ObservableObjectPublisher()
    @ObservationIgnored lazy var debouncePublisher = stateChangePublisher.debounce(for: .seconds(5), scheduler: DispatchQueue.main)
    var state: State = .loading {
        didSet {
            if case .loaded = state {
                stateChangePublisher.send()
            }
        }
    }
    private var lastOutlookType: OutlookType = Context.defaultOutlookType
    
    @MainActor func load(_ type: OutlookType) async {
        lastOutlookType = type
        self.state = .loading
        self.state = .init(fetcherResult: await OutlookFetcher.fetch(outlook: type))
    }
    
    @MainActor func refresh() async {
        await load(lastOutlookType)
    }
}
