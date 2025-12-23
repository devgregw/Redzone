//
//  RedzoneMacrosPlugin.swift
//  RedzoneMacros
//
//  Created by Greg Whatley on 12/18/25.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct RedzoneMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        URLMacro.self
    ]
}
