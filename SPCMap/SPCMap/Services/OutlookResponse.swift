//
//  OutlookResponse.swift
//  SPC
//
//  Created by Greg Whatley on 4/23/23.
//

import Foundation
import SPCCommon

struct OutlookResponse: Codable, Identifiable, Equatable {
    var id: String {
        _date
    }
    
    enum CodingKeys: String, CodingKey {
        case categorical = "cat"
        case hail
        case tornado = "torn"
        case wind
        case prob
        case sigprob
        case _date = "date"
    }
    
    // Used for all requests
    let categorical: [Outlook]?
    private let _date: String
    
    var date: Date? {
        ISO8601DateFormatter().date(from: _date)
    }
    
    // Used for day 1 and 2 requests only
    let wind: [Outlook]?
    let hail: [Outlook]?
    let tornado: [Outlook]?
    
    // Used for day 3 requests only
    let prob: [Outlook]?
    let sigprob: [Outlook]?
}
