//
//  MKMapRect.swift
//  SPCMap
//
//  Created by Greg Whatley on 7/11/23.
//

import MapKit

extension MKMapRect: Comparable {
    public static func < (lhs: MKMapRect, rhs: MKMapRect) -> Bool {
        lhs.area < rhs.area
    }
    
    public static func == (lhs: MKMapRect, rhs: MKMapRect) -> Bool {
        lhs.area == rhs.area
    }
    
    var area: Double {
        width * height
    }
}
