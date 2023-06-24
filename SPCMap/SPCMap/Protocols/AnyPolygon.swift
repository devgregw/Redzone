//
//  AnyPolygon.swift
//  SPC
//
//  Created by Greg Whatley on 4/8/23.
//

import MapKit

protocol AnyPolygon: NSObject, MKOverlay {
    func contains(point: MKMapPoint) -> Bool
}
