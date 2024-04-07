//
//  OutlookMultiPolygon.swift
//  SPCMap
//
//  Created by Greg Whatley on 6/25/23.
//

import MapKit
import SwiftUI

class OutlookMultiPolygon: MKMultiPolygon {
    lazy var strokeColor: Color = properties.isSignificant ? .black : Color(hex: properties.strokeColor)
    lazy var fillColor: Color = properties.isSignificant ? .clear : Color(hex: properties.fillColor).opacity(0.25)
    var dashed: Bool { properties.isSignificant }
    
    let properties: OutlookProperties
    
    init(from polygon: MKMultiPolygon, properties: OutlookProperties) {
        self.properties = properties
        super.init(polygon.polygons)
    }
}
