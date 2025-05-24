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
    
    private func toDate(_ value: String) -> Date? {
        guard let year = Int(value.substring(range: 0..<4)),
              let month = Int(value.substring(range: 4..<6)),
              let day = Int(value.substring(range: 6..<8)),
              let hour = Int(value.substring(range: 8..<10)),
              let minute = Int(value.substring(range: 10..<12))
        else { return nil }
        var components = DateComponents()
        components.calendar = .init(identifier: .gregorian)
        components.timeZone = .gmt
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        return components.date
    }
    
    var expireDate: Date? {
        toDate(expire)
    }
    
    var validDate: Date? {
        toDate(valid)
    }
    
    var issueDate: Date? {
        toDate(issue)
    }
    
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

extension String {
    func substring(range: Range<Int>) -> Substring {
        self[index(startIndex, offsetBy: range.lowerBound)..<index(startIndex, offsetBy: range.upperBound)]
    }
}
