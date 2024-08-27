//
//  ExtensionTests.swift
//  SPCMapTests
//
//  Created by Greg Whatley on 3/11/24.
//

import XCTest
import SwiftUI
import MapKit
import GeoJSON
@testable import SPCMap

final class ExtensionTests: XCTestCase {
    func testColorFromHex() {
        let colors: [String: (String, Color)] = [
            "White": ("#FFFFFF", .white),
            "Black": ("#000000", .black),
            "Red": ("#FF0000", .init(red: 1, green: 0, blue: 0)),
            "Green": ("#00FF00", .init(red: 0, green: 1, blue: 0)),
            "Blue": ("#0000FF", .init(red: 0, green: 0, blue: 1))
        ]
        colors.forEach { (name, values) in
            XCTAssertEqual(Color(hex: values.0), values.1, "Hex \(values.0) to color \(name) failed.")
        }
    }
    
    func testMKMapRect() {
        let rect1 = MKMapRect(x: 0, y: 0, width: 10, height: 100)
        let rect2 = MKMapRect(x: 0, y: 0, width: 5, height: 10)
        XCTAssertEqual(rect1.area, 1000)
        XCTAssertEqual(rect2.area, 50)
        XCTAssertTrue(rect2 < rect1)
        let rect3 = MKMapRect(x: 0, y: 0, width: 10, height: 5)
        XCTAssertEqual(rect2, rect3)
        XCTAssertEqual(rect2.area, rect3.area)
    }
    
    func testArrayFirstKeyPath() {
        let nums = [1, 2, 3, 4, 5, 6]
        let item = nums.first(where: \.isEven)
        XCTAssertEqual(item, 2)
    }
    
    func testArrayFilterNot() {
        let nums = [1, 2, 3, 4, 5, 6]
        let filter = nums.filterNot(by: \.isEven)
        XCTAssertEqual(filter, [1, 3, 5])
    }
    
    func testSplitFilter() {
        let nums = [1, 2, 3, 4, 5, 6]
        let split = nums.splitFilter(by: \.isEven)
        XCTAssertEqual(split.false, [1, 3, 5])
        XCTAssertEqual(split.true, [2, 4, 6])
    }
    
    func testOptional() {
        let a: Int? = 10
        let b: Int? = nil
        XCTAssertFalse(a.isNil)
        XCTAssertTrue(b.isNil)
    }
    
    func testPolygonContains() {
        let polygon = GeoJSONPolygon([
            .init(latitude: 0.0, longitude: 0.0),
            .init(latitude: 10.0, longitude: 0.0),
            .init(latitude: 10.0, longitude: 10.0),
            .init(latitude: 0.0, longitude: 10.0),
            .init(latitude: 0.0, longitude: 0.0)
        ])
        XCTAssertTrue(polygon.contains(point: .init(latitude: 5, longitude: 5)))
        XCTAssertFalse(polygon.contains(point: .init(latitude: 20.0, longitude: 20.0)))
    }
}

private extension Int {
    var isEven: Bool {
        self % 2 == 0
    }
}
