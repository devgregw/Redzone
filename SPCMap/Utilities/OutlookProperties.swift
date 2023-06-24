//
//  OutlookProperties.swift
//  SPC
//
//  Created by Greg Whatley on 6/25/23.
//

import Foundation

final class OutlookProperties {
    let id: String
    let title: String
    
    let fillColor: String
    let strokeColor: String
    
    let expire: String
    let valid: String
    let issue: String
    
    lazy var severity: OutlookSeverity = .init(rawValue: id)
    
    lazy var isSignificant: Bool = severity == .significant
    
    init(id: String, title: String, fillColor: String, strokeColor: String, expire: String, valid: String, issue: String) {
        self.id = id
        self.title = title
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.expire = expire
        self.valid = valid
        self.issue = issue
    }
}

extension OutlookProperties: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "LABEL"
        case title = "LABEL2"
        case fillColor = "fill"
        case strokeColor = "stroke"
        case expire = "EXPIRE"
        case valid = "VALID"
        case issue = "ISSUE"
    }
}
