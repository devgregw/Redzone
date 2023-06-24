//
//  Set.swift
//  SPC
//
//  Created by Greg Whatley on 4/2/23.
//

import Foundation

extension Set {
    mutating func subtract(andReturnIntersectionOf other: Set<Element>) -> Set<Element> {
        let intersection = self.intersection(other)
        self.subtract(other)
        return intersection
    }
    
    @inlinable var asArray: [Element] {
        Array(self)
    }
}
