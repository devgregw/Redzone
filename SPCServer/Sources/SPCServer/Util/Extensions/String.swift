//
//  String.swift
//
//
//  Created by Greg Whatley on 6/29/23.
//

import Foundation

extension String {
    func substring(_ range: Range<Int>) -> Substring {
        self[index(startIndex, offsetBy: range.lowerBound)..<index(startIndex, offsetBy: range.upperBound)]
    }
}
