//
//  OutlookFetcher.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/6/24.
//

import Foundation

func apply<T>(_ value: T, operation: (inout T) -> Void) -> T {
    var value = value
    operation(&value)
    return value
}

class OutlookFetcher {
    private static let hostname: String = "https://ct106-spc.pve.gregwhatley.dev"
    
    static let session: URLSession = apply(.init(configuration: .ephemeral)) {
        $0.configuration.waitsForConnectivity = true
        $0.configuration.timeoutIntervalForRequest = 30
        $0.configuration.timeoutIntervalForResource = 30
    }
    
    static func fetch(outlook: OutlookType) async -> Result<OutlookResponse, OutlookFetcherError> {
        if let url = URL(string: "\(hostname)/\(outlook.path)") {
            do {
                let (data, urlResponse) = try await session.data(from: url)
                if let httpResponse = urlResponse as? HTTPURLResponse,
                   httpResponse.statusCode == 204 {
                    return .failure(.noData)
                } else {
                    let response = try OutlookResponse(data: data, outlookType: outlook)
                    if response.features.isEmpty {
                        return .failure(OutlookFetcherError.noData)
                    } else {
                        return .success(response)
                    }
                }
            } catch {
                return .failure(.networkError(cause: error))
            }
        } else {
            return .failure(.unknown(message: "Invalid outlook specified"))
        }
    }
}
