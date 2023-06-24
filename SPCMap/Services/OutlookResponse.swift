//
//  OutlookResponse.swift
//  SPC
//
//  Created by Greg Whatley on 6/19/23.
//

import MapKit

class OutlookResponse: Hashable {
    let features: [OutlookFeature]
    let outlookType: OutlookType
    
    init(data: Data, outlookType: OutlookType) throws {
        features = try MKGeoJSONDecoder().decode(data).compactMap { $0 as? MKGeoJSONFeature }.map(OutlookFeature.init(from:))
        self.outlookType = outlookType
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(features.hashValue)
        hasher.combine(outlookType.hashValue)
    }
    
    static func == (lhs: OutlookResponse, rhs: OutlookResponse) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
