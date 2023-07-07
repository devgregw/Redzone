//
//  TappedOutlook.swift
//  SPC
//
//  Created by Greg Whatley on 6/25/23.
//

import Foundation

struct TappedOutlook: Hashable, Identifiable {
    let highestRisk: OutlookMultiPolygon
    let isSignificant: Bool
    
    var id: Int {
        hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(highestRisk.hashValue)
        hasher.combine(isSignificant)
    }
}
