//
//  OutlookFetcher.swift
//  Redzone
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
    private static let hostname: String = "https://redzone-main--redzone-6a505.us-central1.hosted.app/api"
    
    static let session: URLSession = apply(.init(configuration: .ephemeral)) {
        $0.configuration.waitsForConnectivity = true
        $0.configuration.timeoutIntervalForRequest = 30
        $0.configuration.timeoutIntervalForResource = 30
    }
    
    static func fetch(outlook: OutlookType) async -> Result<OutlookResponse, OutlookFetcherError> {
#if DEBUG
        if UserDefaults.standard.bool(forKey: AppStorageKeys.useMockData) {
            Logger.log(.outlookService, "WARNING: Using mocked data.")
            let fileName: String
            switch outlook {
            case .convective1(.categorical): fileName = "day1otlk_20250608_2000_cat.lyr"
            case .convective1(.wind): fileName = "day1otlk_20250608_2000_wind.lyr"
            case .convective1(.hail): fileName = "day1otlk_20250608_2000_hail.lyr"
            case .convective1(.tornado): fileName = "day1otlk_20250608_2000_torn.lyr"
            default: return .failure(.noData)
            }
            guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "geojson") else {
                return .failure(.unknown(message: "Failed to open mock data file."))
            }
            do {
                return .success(try OutlookResponse(data: Data(contentsOf: fileURL), outlookType: outlook))
            } catch {
                return .failure(.networkError(cause: error))
            }
        }
#endif
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
