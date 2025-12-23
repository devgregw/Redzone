//
//  Foundation.swift
//  RedzoneCore
//
//  Created by Greg Whatley on 9/27/25.
//

import Foundation

// MARK: - Result extensions

public extension Result {
    var value: Success? {
        guard case let .success(success) = self else { return nil }
        return success
    }

    var error: Failure? {
        guard case let .failure(failure) = self else { return nil }
        return failure
    }
}

// MARK: - Property List extensions

/// A protocol to which all property list value types conform.
public protocol PropertyListValue: Sendable { }

/// A protocol to which all atomic property list value types, such as strings and numbers, conform.
public protocol AtomicPropertyListValue: PropertyListValue, Equatable { }

/// A property list dictionary.
public typealias PropertyList = [String: any PropertyListValue]

extension Data: AtomicPropertyListValue, PropertyListValue { }
extension String: AtomicPropertyListValue, PropertyListValue { }
extension Date: AtomicPropertyListValue, PropertyListValue { }
extension Int: AtomicPropertyListValue, PropertyListValue { }
extension Float: AtomicPropertyListValue, PropertyListValue { }
extension Double: AtomicPropertyListValue, PropertyListValue { }
extension Bool: AtomicPropertyListValue, PropertyListValue { }
extension Array: PropertyListValue where Element == any PropertyListValue { }
extension PropertyList: PropertyListValue { }

/// Coerces an arbitrary item to a `PropertyListValue` if possible.
private func coerceToPropertyListValue(_ item: Any) -> (any PropertyListValue)? {
    if let dictionary = item as? [String: Any] {
        dictionary.compactMapValues(coerceToPropertyListValue(_:))
    } else if let array = item as? [Any] {
        array.compactMap(coerceToPropertyListValue(_:))
    } else if let data = item as? Data {
        data
    } else if let string = item as? String {
        string
    } else if let bool = item as? Bool {
        bool
    } else if let float = item as? Float {
        float
    } else if let double = item as? Double {
        double
    } else if let int = item as? Int {
        int
    } else if let date = item as? Date {
        date
    } else {
        nil
    }
}

public extension Dictionary where Key == String, Value == Any {
    /// Coerces the dictionary to a `PropertyList` by mapping all values to `PropertyListValue`s where possible.
    func coercedToPropertyList() -> PropertyList {
        compactMapValues(coerceToPropertyListValue(_:))
    }
}
