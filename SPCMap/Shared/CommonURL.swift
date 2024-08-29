//
//  CommonURL.swift
//  SPCMapWidgets
//
//  Created by Greg Whatley on 8/18/24.
//

import Foundation

enum CommonURL: Hashable {
    private func makeURL(queryItems: [String: String]) -> URL? {
        var components = URLComponents()
        components.scheme = "whatley"
        components.host = "spcapp"
        components.queryItems = queryItems.map { .init(name: $0.key, value: $0.value) }
        return components.url
    }
    
    case setOutlook(to: OutlookDay)
    
    var rawValue: URL? {
        return switch self {
        case let .setOutlook(day):
            makeURL(queryItems: ["setOutlook": String(day.rawValue)])
        }
    }
}
