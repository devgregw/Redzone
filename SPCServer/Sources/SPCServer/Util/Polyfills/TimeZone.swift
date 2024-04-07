//
//  TimeZone.swift
//  
//
//  Created by Greg Whatley on 4/6/24.
//

#if os(Linux)

import Foundation

extension TimeZone {
    static var gmt: TimeZone { .init(abbreviation: "UTC")! }
}

#endif
