//
//  ApplicationTests.swift
//  
//
//  Created by Greg Whatley on 5/9/23.
//

@testable import SPCServer
import XCTest
import XCTVapor

final class ApplicationTests: XCTestCase {
    var app: Application!
    
    override func setUp() async throws {
        app = try await .make(.testing)
        try await configure(app)
    }
    
    override func tearDown() async throws {
        try await app.asyncShutdown()
    }
    
    /* func testCache() async throws {
        let outlook = OutlookType.convectiveDay1
        
        let expectedUrl = try await Scraper.scrapeZipURL(outlook: outlook)
        
        try app.test(.GET, outlook.rawValue, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotNil(ArchiveCache.checkCache(for: outlook, currentURL: expectedUrl))
        })
    } */
}

