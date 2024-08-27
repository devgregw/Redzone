//
//  Array.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/2/23.
//

import Foundation

extension Array {
    @inlinable func filterNot(by keyPath: KeyPath<Element, Bool>) -> Array<Element> {
        self.filter { !$0[keyPath: keyPath] }
    }
    
    @inlinable func first(where keyPath: KeyPath<Element, Bool>) -> Element? {
        self.first { $0[keyPath: keyPath] }
    }
}

extension Collection {
    func splitFilter(by path: KeyPath<Element, Bool>) -> (`true`: [Element], `false`: [Element]) {
        var `true`: [Element] = []
        var `false`: [Element] = []
        forEach {
            if $0[keyPath: path] {
                `true`.append($0)
            } else {
                `false`.append($0)
            }
        }
        return (true: `true`, false: `false`)
    }
    
    func flattened<ElementOfResult>() -> [ElementOfResult] where Element == [ElementOfResult] {
        flatMap { $0 }
    }
}
