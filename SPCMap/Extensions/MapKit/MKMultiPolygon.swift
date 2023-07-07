//
//  MKMultiPolygon.swift
//  SPC
//
//  Created by Greg Whatley on 4/8/23.
//

import MapKit

protocol AnyPolygon: NSObject {
    func contains(point: MKMapPoint) -> Bool
}

extension MKMultiPolygon: AnyPolygon {
    func contains(point: MKMapPoint) -> Bool {
        polygons.contains {
            $0.contains(point: point)
        }
    }
}
