//
//  OutlookFetcher.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/6/24.
//

import Foundation

class OutlookFetcher {
    private static let hostname: String = "https://ct106-spc.pve.gregwhatley.dev:8081"
    
    static let session: URLSession = .init(configuration: .ephemeral)
    
    static func fetch(outlook: OutlookType) async -> Result<OutlookResponse, OutlookFetcherError> {
        if let url = URL(string: "\(hostname)/\(outlook.path)") {
            do {
                let (data, urlResponse) = try await session.data(from: url)
                if let httpResponse = urlResponse as? HTTPURLResponse,
                   httpResponse.statusCode == 204 {
                    return .failure(.noData)
                } else {
                    let response = try OutlookResponse(data: data, outlookType: outlook)
                    if response.features.first?.geometry.isEmpty ?? true {
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
