//
//  TappedOutlook.swift
//  SPCMap
//
//  Created by Greg Whatley on 6/25/23.
//

import Foundation
import GeoJSON

struct TappedOutlook: Hashable, Identifiable {
    let highestRisk: GeoJSONFeature
    let isSignificant: Bool
    
    var id: Int {
        hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(highestRisk.hashValue)
        hasher.combine(isSignificant)
    }
}
