//
//  MKMapView.swift
//  SPC
//
//  Created by Greg Whatley on 4/8/23.
//

import MapKit

extension MKMapView {
    func polygon(at point: MKMapPoint) -> (AnyPolygon, Bool)? {
        let mappedPolygons = overlays.compactMap { $0 as? AnyPolygon }.map { ($0, $0.accessibilityLabel?.split(separator: ",", omittingEmptySubsequences: false)[2] == "true") }
        let significant = mappedPolygons.first { $0.1 }?.0.contains(point: point) ?? false
        if let insignificantPolygon = mappedPolygons.filterNot(by: \.1).first(where: { $0.0.contains(point: point) }) {
            return (insignificantPolygon.0, significant)
        } else {
            return nil
        }
    }
}
