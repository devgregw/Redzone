//
//  CLLocationCoordinate2D.swift
//  Redzone
//
//  Created by Greg Whatley on 4/28/24.
//

import CoreLocation
import Foundation

extension CLLocationCoordinate2D: Codable {
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            latitude: try container.decode(CLLocationDegrees.self, forKey: .latitude),
            longitude: try container.decode(CLLocationDegrees.self, forKey: .longitude)
        )
    }
}
