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
        return try Data(contentsOf: Mocks.cat.json)
    })

    @Test("Fetch outlook and find by location") func testFetch() async throws {
        let response = try await service.fetchOutlook(type: .convective(.day1(.categorical)))
        let coordinate = CLLocationCoordinate2D(latitude: 33.5175, longitude: -86.809444)
        let locationOutlook = try #require(response.findRisks(at: coordinate)?[.convectivePrimary])
        #expect(locationOutlook.id == "HIGH")
        #expect(locationOutlook.properties.severity == .high)
    }
}
