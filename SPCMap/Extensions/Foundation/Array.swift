//
//  Array.swift
//  SPC
//
//  Created by Greg Whatley on 4/2/23.
//

import CoreLocation
import Foundation

extension Array {
    @inlinable func filterNot(by keyPath: KeyPath<Element, Bool>) -> Array<Element> {
        self.filter { !$0[keyPath: keyPath] }
    }
    
    @inlinable func filter<E>(where keyPath: KeyPath<Element, E>, equals value: E) -> Array<Element> where E: Equatable {
        self.filter { $0[keyPath: keyPath] == value }
    }
    
    @inlinable func first(where keyPath: KeyPath<Element, Bool>) -> Element? {
        self.first { $0[keyPath: keyPath] }
    }
    
    @inlinable func first<E>(where keyPath: KeyPath<Element, E>, equals value: E) -> Element? where E: Equatable {
        self.first { $0[keyPath: keyPath] == value }
    }
    
    @inlinable func sorted<C>(on keyPath: KeyPath<Element, C>, by comparator: (C, C) throws -> Bool) rethrows -> Array<Element> where C: Comparable {
        try self.sorted { a, b in try comparator(a[keyPath: keyPath], b[keyPath: keyPath]) }
    }
}

extension LazySequence {
    @inlinable func compactCast<T>(to: T.Type) -> [T] {
        compactMap { $0 as? T }
    }
}
