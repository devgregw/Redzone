//
//  RequestAdapter.swift
//  RedzoneCore
//
//  Created by Greg Whatley on 9/19/25.
//

import Foundation
import OSLog

private let logger: Logger = .create()

public protocol RequestAdapter: Sendable {
    func data(for url: URL) async throws -> Data
}

public extension RequestAdapter {
    func data<T>(for url: URL) async throws -> T where T: Decodable {
        let response = try await data(for: url)
        do {
            logger.debug("Decoding response as '\(T.self)'.")
            return try JSONDecoder().decode(T.self, from: response)
        } catch {
            logger.error("Caught '\(error.self)' while decoding response as '\(T.self)' for '\(url)'.")
            throw error
        }
    }
}
