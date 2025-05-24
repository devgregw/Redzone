//
//  Collection.swift
//  Redzone
//
//  Created by Greg Whatley on 8/20/24.
//

import CoreLocation
import Foundation
import MapKit

extension Collection {
    @inlinable func split(on path: KeyPath<Element, Bool>) -> (`true`: [Element], `false`: [Element]) {
        reduce(into: (true: [], false: [])) {
            if $1[keyPath: path] {
                $0.true.append($1)
            } else {
                $0.false.append($1)
            }
        }
    }
    
    @inlinable func flattened<ElementOfResult>() -> [ElementOfResult] where Element == [ElementOfResult] {
        flatMap { $0 }
    }
}
