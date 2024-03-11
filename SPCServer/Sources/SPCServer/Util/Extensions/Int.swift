//
//  Int.swift
//
//
//  Created by Greg Whatley on 6/19/23.
//

import Foundation

extension Int {
    func stringByPaddingZeroes(length: Int) -> String {
        let current = "\(self)"
        return String(repeating: "0", count: Swift.max(0, length - current.count)) + current
    }
}
