//
//  OutlookProperties.swift
//  SPCMap
//
//  Created by Greg Whatley on 6/25/23.
//

import Foundation
import SwiftUI

struct OutlookProperties {
    let id: String
    let title: String
    
    let fillColor: Color
    let strokeColor: Color
    
    // periphery:ignore
    let expire: String
    // periphery:ignore
    let valid: String
    // periphery:ignore
    let issue: String
    
    let severity: OutlookSeverity
    let isSignificant: Bool
    
    init(id: String, title: String, fillColor: String, strokeColor: String, expire: String, valid: String, issue: String) {
        self.id = id
        self.title = title
        self.expire = expire
        self.valid = valid
        self.issue = issue
        self.severity = .init(rawValue: id)
        self.isSignificant = severity == .significant
        self.fillColor = isSignificant ? .clear : Color(hex: fillColor)
        self.strokeColor = isSignificant ? .black : Color(hex: strokeColor)
    }
}
