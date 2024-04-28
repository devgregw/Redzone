//
//  Logger.swift
//  SPCMap
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
    
    static func log(_ scope: Scope, _ message: String) {
        #if DEBUG
        print("[SPCMap] [\(scope.rawValue.capitalized)] \(message)")
        #endif
    }
}
