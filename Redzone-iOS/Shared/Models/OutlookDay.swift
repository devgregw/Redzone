//
//  OutlookDay.swift
//  RedzoneWidgets
//
//  Created by Greg Whatley on 4/7/24.
//

import Foundation
import AppIntents

enum OutlookDay: Int, AppEnum {
    case day1 = 1
    case day2 = 2
    
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Outlook Day"
    static let caseDisplayRepresentations: [OutlookDay : DisplayRepresentation] = [
        .day1: "Day 1 (today)",
        .day2: "Day 2 (tomorrow)"
    ]
}
