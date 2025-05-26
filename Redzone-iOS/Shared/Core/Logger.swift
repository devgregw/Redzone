//
//  Logger.swift
//  Redzone
//
//  Created by Greg Whatley on 4/8/24.
//

import Foundation

class Logger {
    enum Scope: String {
        case settings
        case widgets
        case locationService
        case outlookService
        case map
    }
    private init() { }
    
    @inlinable static func log(_ scope: Scope, _ message: String) {
        print("[Redzone] [\(scope.rawValue)] \(message)")
    }
}
