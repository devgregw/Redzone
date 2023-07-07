//
//  MKMapView.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/8/23.
//

import MapKit

extension MKMapView {
    func polygon(at point: MKMapPoint) -> TappedOutlook? {
        let mappedPolygons = overlays.compactMap { $0 as? OutlookMultiPolygon }.filter { $0.contains(point: point) }
        guard !mappedPolygons.isEmpty,
              let highestRisk = mappedPolygons.filterNot(by: \.dashed).max(by: { a, b in b.properties.severity > a.properties.severity }) else { return nil }
        let significant = mappedPolygons.contains { $0.dashed }
        return .init(highestRisk: highestRisk, isSignificant: significant)
    }
}
