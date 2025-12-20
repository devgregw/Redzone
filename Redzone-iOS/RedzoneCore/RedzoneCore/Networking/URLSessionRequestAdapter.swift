//
//  URLSessionRequestAdapter.swift
//  RedzoneCore
//
//  Created by Greg Whatley on 9/19/25.
//

import Foundation
import OSLog

public struct URLSessionRequestAdapter: RequestAdapter {
    private static let logger: Logger = .create()

    let session: URLSession

    public func data(for url: URL) async throws -> Data {
        do {
            Self.logger.debug("Handling request for '\(url)'.")
            let (data, response) = try await session.data(from: url)
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
    static var urlSession: URLSessionRequestAdapter {
        .urlSession(.shared)
    }

    static func urlSession(_ session: URLSession) -> URLSessionRequestAdapter {
        .init(session: session)
    }
}
