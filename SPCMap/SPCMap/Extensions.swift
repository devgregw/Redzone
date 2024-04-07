//
//  Extensions.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/6/24.
//

import Foundation
import MapKit

extension Collection where Element == OutlookFeature {
    func findTappedOutlook(at coordinate: CLLocationCoordinate2D) -> TappedOutlook? {
        let allPolygons = flatMap { $0.multiPolygons }
        let mapPoint = MKMapPoint(coordinate)
        
        let (significantPolygons, otherPolgons) = allPolygons.splitFilter(by: \.dashed)
        let tappedPolygon = otherPolgons.reversed().first { $0.contains(point: mapPoint) }
        
        guard let tappedPolygon else {
            return .none
        }
        
        let isSignificant = significantPolygons.contains { $0.contains(point: mapPoint) }
        
        return .init(highestRisk: tappedPolygon, isSignificant: isSignificant)
    }
}
