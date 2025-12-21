//
//  OutlookServiceTests.swift
//  RedzoneCoreTests
//
//  Created by Greg Whatley on 9/19/25.
//

import CoreLocation
import Foundation
@testable import RedzoneCore
import Testing

@Suite("OutlookService") struct OutlookServiceTests {

    private let service = OutlookService(adapter: CustomRequestAdapter {
        #expect(Set(OutlookType.convective(.day1(.categorical)).pathSegments).isSubset(of: Set($0.pathComponents)))
        return try Data(contentsOf: Mocks.cat.geojson)
    })

    @Test("Fetch outlook and find by location") func testFetch() async throws {
        let response = try await service.fetchOutlook(type: .convective(.day1(.categorical)))
        #expect(response.outlookType == .convective(.day1(.categorical)))

        let coordinate = CLLocationCoordinate2D(latitude: 33.216389, longitude: -97.129167)
        let locationOutlook = try #require(response.findOutlook(containing: coordinate))
        #expect(locationOutlook.highestRisk.id == "MDT")
        #expect(locationOutlook.highestRisk.properties.severity == .moderate)
        #expect(locationOutlook.significantFeature == nil)
    }
}
