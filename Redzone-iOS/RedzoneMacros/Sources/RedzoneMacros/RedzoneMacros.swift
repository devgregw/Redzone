//
//  RedzoneMacros.swift
//  RedzoneMacros
//
//  Created by Greg Whatley on 12/18/25.
//

import Foundation
import OSLog

/// A macro that validates and unwraps a URL from a String at compile time.
@freestanding(expression)
public macro URL<S: ExpressibleByStringLiteral>(_ string: S) -> URL =
    #externalMacro(module: "RedzoneMacrosInternal", type: "URLMacro")

/// A macro that validates and unwraps a URL from a String at compile time.
@freestanding(expression)
public macro URL<S: ExpressibleByStringLiteral>(_ string: S, relativeTo: URL?) -> URL =
    #externalMacro(module: "RedzoneMacrosInternal", type: "URLMacro")
