//
//  URLSessionAdapter.swift
//
//
//  Created by Greg Whatley on 2/7/24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Vapor

actor URLSessionAdapter {
    static let shared: URLSessionAdapter = .init()
    
    private init() {
        
    }
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: .init(url: url)) { data, response, error in
                if let data, let response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: error ?? Abort(.internalServerError))
                }
            }.resume()
        }
    }
}
