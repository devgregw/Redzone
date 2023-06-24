//
//  NewResponse.swift
//  SPC
//
//  Created by Greg Whatley on 6/19/23.
//

import Foundation
import MapKit

class OutlookFeature: MKGeoJSONFeature {
    struct OutlookProperties: Codable {
        enum CodingKeys: String, CodingKey {
            case id = "LABEL"
            case title = "LABEL2"
            case fillColor = "fill"
            case strokeColor = "stroke"
            case expire = "EXPIRE"
            case valid = "VALID"
            case issue = "ISSUE"
        }
        
        let id: String
        let title: String
        
        let fillColor: String
        let strokeColor: String
        
        let expire: String
        let valid: String
        let issue: String
    }
    
    lazy var outlookProperties: OutlookProperties? = {
        guard let properties else { return nil }
        return try? JSONDecoder().decode(OutlookProperties.self, from: properties)
    }()
}

class OutlookResponse2 {
    let features: [OutlookFeature]
    let outlookType: OutlookType2
    
    init(data: Data, outlookType: OutlookType2) throws {
        features = try MKGeoJSONDecoder().decode(data).compactMap { $0 as? OutlookFeature }
        self.outlookType = outlookType
    }
}
