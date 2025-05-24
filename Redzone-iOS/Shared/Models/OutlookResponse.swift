//
//  OutlookResponse.swift
//  Redzone
//
//  Created by Greg Whatley on 6/19/23.
//

import Foundation
import GeoJSON

final class OutlookResponse: Hashable, Sendable {
    let features: [GeoJSONFeature]
    let outlookType: OutlookType
    
    init(data: Data, outlookType: OutlookType) throws {
        let object = try GeoJSONDecoder().decode(data, options: .swapLatitudeLongitude)
        self.features = object.features ?? []
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
