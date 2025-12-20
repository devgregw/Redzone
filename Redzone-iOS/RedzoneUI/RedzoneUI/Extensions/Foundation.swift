//
//  Foundation.swift
//  RedzoneUI
//
//  Created by Greg Whatley on 9/30/25.
//

import Foundation

public extension CustomStringConvertible where Self: CustomLocalizedStringResourceConvertible {
    var description: String {
        String(localized: localizedStringResource)
    }
}
