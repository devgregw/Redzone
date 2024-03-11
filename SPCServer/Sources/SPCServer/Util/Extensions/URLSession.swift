//
//  URLSession.swift
//
//
//  Created by Greg Whatley on 2/6/24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Vapor

extension URLSession {
    static let defaultSession: URLSession = .init(configuration: .default)
    
    func fetch(from url: URL) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            dataTask(with: .init(url: url)) { data, response, error in
                if let data, let response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: error ?? Abort(.internalServerError))
                }
            }.resume()
        }
    }
}


