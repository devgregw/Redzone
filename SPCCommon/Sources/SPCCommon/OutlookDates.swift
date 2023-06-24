//
//  OutlookDates.swift
//  SPC
//
//  Created by Greg Whatley on 4/7/23.
//

import Foundation

public struct OutlookDates: Codable {
    let rawValid: Int?
    let rawExpire: Int?
    let rawIssue: Int?
    
    private func parseDate(from path: KeyPath<Self, Int?>) -> Date? {
        guard let raw = self[keyPath: path] else {
            return nil
        }
        let str = String(raw)
        let formatter = DateFormatter()
        formatter.timeZone = .init(abbreviation: "UTC")
        formatter.calendar = .current
        formatter.dateFormat = "YYYYMMddhhmm"
        return formatter.date(from: str)
    }
    
    public var valid: Date? {
        parseDate(from: \.rawValid)
    }
    
    public var expire: Date? {
        parseDate(from: \.rawExpire)
    }
    
    public var issue: Date? {
        parseDate(from: \.rawIssue)
    }
    
    enum CodingKeys: String, CodingKey {
        case rawValid = "valid"
        case rawExpire = "expire"
        case rawIssue = "issue"
    }
}
