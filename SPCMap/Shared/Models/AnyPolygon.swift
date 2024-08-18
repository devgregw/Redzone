//
//  AnyPolygon.swift
//  SPCMap
//
//  Created by Greg Whatley on 7/11/23.
//

import Foundation
import MapKit

protocol AnyPolygon: NSObject {
    // periphery:ignore - False positive.
    func contains(point: MKMapPoint) -> Bool
}
