//
//  ResultTests.swift
//  RedzoneCore
//
//  Created by Greg Whatley on 12/18/25.
//

@testable import RedzoneCore
import Testing

@Suite("Result Extensions") struct ResultTests {
    private enum TestError: Error {
        case error
    }

    @Test("Result.value") func testResultValue() {
        let result = Result<Int, TestError>.success(1)
        #expect(result.value == 1)
        #expect(result.error == nil)
    }

    @Test("Result.error") func testResultError() {
        let result = Result<Int, TestError>.failure(.error)
        #expect(result.value == nil)
        #expect(result.error == .error)
    }
}
