//
//  OutlookService.swift
//  RedzoneCore
//
//  Created by Greg Whatley on 9/19/25.
//

import CoreLocation
import Foundation
import OSLog
internal import RedzoneMacros

public final actor OutlookService: NetworkingService {
    private static let logger: Logger = .create()

    public enum FetchingError: Error {
        case malformedURL
        case noRiskForecast
    }

    private let hostname = #URL("https://redzone.gregwhatley.dev/api/")
    public let adapter: any RequestAdapter

    public init(adapter: any RequestAdapter) {
        self.adapter = adapter
        Self.logger.debug("Outlook service initialized.")
    }

    nonisolated public func fetchOutlook(type: OutlookType) async throws -> OutlookResponse {
        let path = type.pathSegments.joined(separator: "/")
        guard let url = URL(string: path, relativeTo: hostname) else {
            Self.logger.fault("Unexpectedly found a malformed URL for '\(String(describing: type))' (\(path)).")
            throw FetchingError.malformedURL
        }

        let data = try await adapter.data(for: url)
        return try OutlookResponse(data: data, outlookType: type)
    }
}
