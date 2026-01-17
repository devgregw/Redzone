//
//  URLMacro.swift
//  RedzoneMacros
//
//  Created by Greg Whatley on 12/18/25.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct URLMacro: ExpressionMacro {
    public enum MacroError: String, Error, CustomStringConvertible {
        case inputNotAStringLiteral = "#URL requires a string literal as input."
        case malformedURL = "URL is malformed."

        public var description: String { rawValue }
    }

    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard let argument = node.arguments.first?.expression,
              let segments = argument.as(StringLiteralExprSyntax.self)?.segments
        else {
            throw MacroError.inputNotAStringLiteral
        }

        guard URL(string: segments.description) != nil else {
            throw MacroError.malformedURL
        }

        if node.arguments.count == 2 {
            let relativeTo = node.arguments[node.arguments.index(at: 1)].expression
            return "URL(string: \(argument), relativeTo: \(relativeTo))!"
        } else {
            return "URL(string: \(argument))!"
        }
    }
}
