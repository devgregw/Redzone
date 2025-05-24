//
//  MKMapRect.swift
//  Redzone
//
//  Created by Greg Whatley on 7/11/23.
//

import MapKit

extension MKMapRect: @retroactive Comparable, @retroactive Equatable {
    public static func < (lhs: MKMapRect, rhs: MKMapRect) -> Bool {
        lhs.area < rhs.area
    }
    
    public static func == (lhs: MKMapRect, rhs: MKMapRect) -> Bool {
        lhs.area == rhs.area
    }
}

extension MKMapRect {
    var area: Double {
        width * height
    }
}
