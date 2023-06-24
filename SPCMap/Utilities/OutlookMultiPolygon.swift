//
//  OutlookMultiPolygon.swift
//  SPC
//
//  Created by Greg Whatley on 6/25/23.
//

import MapKit
import UIKit

class OutlookMultiPolygon: MKMultiPolygon {
    lazy var strokeColor: UIColor = properties.isSignificant ? .black : UIColor(hex: properties.strokeColor)
    lazy var fillColor: UIColor = properties.isSignificant ? .clear : UIColor(hex: properties.fillColor).withAlphaComponent(0.25)
    var dashed: Bool { properties.isSignificant }
    
    let properties: OutlookProperties
    
    init(from polygon: MKMultiPolygon, properties: OutlookProperties) {
        self.properties = properties
        super.init(polygon.polygons)
    }
}
