//
//  URLSessionRequestAdapter.swift
//  RedzoneCore
//
//  Created by Greg Whatley on 9/19/25.
//

import Foundation
import OSLog

public typealias TokenGenerator = @Sendable () async throws -> String

public struct URLSessionRequestAdapter: RequestAdapter {
    private static let logger: Logger = .create()

    let session: URLSession
    let tokenGenerator: TokenGenerator

    public func data(for url: URL) async throws -> Data {
        do {
            Self.logger.debug("Handling request for '\(url)'.")
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue(try await tokenGenerator(), forHTTPHeaderField: "X-Firebase-AppCheck")
            let (data, response) = try await session.data(for: request)
            let statusCode = (response as? HTTPURLResponse)?.statusCode.formatted() ?? "?"
            Self.logger.debug("Code \(statusCode): received \(data.count) bytes (\(response.mimeType ?? "?")) for '\(url)'.")
            return data
        } catch {
            Self.logger.error("Caught '\(String(describing: error.self))' for '\(url)'.")
            throw error
        }
    }
}

public extension RequestAdapter where Self == URLSessionRequestAdapter {
    static func urlSession(_ session: URLSession = .shared, tokenGenetator: @escaping TokenGenerator) -> URLSessionRequestAdapter {
        .init(session: session, tokenGenerator: tokenGenetator)
    }
}
