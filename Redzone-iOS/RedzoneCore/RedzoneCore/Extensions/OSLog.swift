//
//  OSLog.swift
//  RedzoneCore
//
//  Created by Greg Whatley on 9/19/25.
//

import Foundation
import OSLog

extension Logger {
    public static func create(category: String = #fileID) -> Logger {
        .init(subsystem: Bundle.main.bundleIdentifier ?? "<unknown>", category: category)
    }
}
