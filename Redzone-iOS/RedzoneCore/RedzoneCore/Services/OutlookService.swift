//
//  OutlookService.swift
//  RedzoneCore
//
//  Created by Greg Whatley on 9/19/25.
//

import CoreLocation
import Foundation
import GeoJSON
import OSLog
internal import RedzoneMacros

public final actor OutlookService: NetworkingService {
    private static let logger: Logger = .create()
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        // swiftlint:disable:next force_unwrapping
        decoder.userInfo[CodingUserInfoKey(rawValue: "GeoJSONDecoderOptions")!] = GeoJSONDecoderOptions.swapLatitudeLongitude
        return decoder
    }()

    public enum FetchingError: Error {
        case malformedURL
        case noRiskForecast
    }

    private let hostname = #URL("https://redzone.gregwhatley.dev/api/v2/")
    public let adapter: any RequestAdapter

    public init(adapter: any RequestAdapter) {
        self.adapter = adapter
        Self.logger.debug("Outlook service initialized.")
    }

    nonisolated public func fetchOutlook(type: OutlookType) async throws -> OutlookCollection {
        let path = type.pathSegments.joined(separator: "/")
        guard let url = URL(string: path, relativeTo: hostname) else {
            Self.logger.fault("Unexpectedly found a malformed URL for '\(String(describing: type))' (\(path)).")
            throw FetchingError.malformedURL
        }

        let data = try await adapter.data(for: url)
        return try Self.decoder.decode(OutlookCollection.self, from: data)
    }
}
