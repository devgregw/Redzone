//
//  String.swift
//  SPCMap
//
//  Created by Greg Whatley on 5/24/25.
//

extension String {
    func substring(range: Range<Int>) -> Substring {
        self[index(startIndex, offsetBy: range.lowerBound)..<index(startIndex, offsetBy: range.upperBound)]
    }
}
