//
//  String.swift
//  SPC
//
//  Created by Greg Whatley on 4/2/23.
//

import Foundation

extension String {
    func substring(count: Int) -> Substring {
        substring(start: 0, count: count)
    }
    
    func substring(start: Int, count: Int) -> Substring {
        let a = index(startIndex, offsetBy: start)
        let b = index(a, offsetBy: count)
        return self[a..<b]
    }
}

extension Substring {
    var string: String {
        "\(self)"
    }
}
