//
//  CustomRequestAdapter.swift
//  RedzoneCore
//
//  Created by Greg Whatley on 9/19/25.
//

import Foundation
import OSLog

public struct CustomRequestAdapter: RequestAdapter {
    private static let logger: Logger = .create()

    let handler: @MainActor (URL) async throws -> Data

    public func data(for url: URL) async throws -> Data {
        do {
            Self.logger.debug("Handling request for '\(url)'.")
            let data = try await handler(url)
            Self.logger.debug("Received \(data.count) bytes for '\(url)'.")
            return data
        } catch {
            Self.logger.error("Caught '\(type(of: error))' for '\(url)'.")
            throw error
        }
    }
}

public extension RequestAdapter where Self == CustomRequestAdapter {
    static func custom(_ handler: @MainActor @escaping (URL) async throws -> Data) -> Self {
        .init(handler: handler)
    }
}
