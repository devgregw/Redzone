//
//  FormatStyle.swift
//
//
//  Created by Greg Whatley on 4/6/24.
//

import Foundation

#if os(Linux)

protocol FormatStyle : Decodable, Encodable, Hashable {

    /// The type of data to format.
    associatedtype FormatInput

    /// The type of the formatted data.
    associatedtype FormatOutput

    /// Creates a `FormatOutput` instance from `value`.
    func format(_ value: Self.FormatInput) -> Self.FormatOutput
}

typealias PolyfillFormatStyle = SPCServer.FormatStyle

extension Date {
    func formatted<F>(_ format: F) -> F.FormatOutput where F : SPCServer.FormatStyle, F.FormatInput == Date {
        format.format(self)
    }
}

#else

typealias PolyfillFormatStyle = Foundation.FormatStyle

#endif
