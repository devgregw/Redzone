//
//  OutlookMapViewCoordinator.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/7/23.
//

import SwiftUI
import MapKit

class OutlookMapViewCoordinator: NSObject {
    let onOutlookTap: (TappedOutlook) -> Void
    
    init(onOutlookTap: @escaping (TappedOutlook) -> Void) {
        self.onOutlookTap = onOutlookTap
    }
}

extension OutlookMapViewCoordinator: MKMapViewDelegate {
    @objc func mapView(gestureRecognized tap: UITapGestureRecognizer) {
        if let mapView = tap.view as? MKMapView,
           tap.state == .recognized {
            let tapLocation = tap.location(in: mapView)
            let mapPoint = MKMapPoint(mapView.convert(tapLocation, toCoordinateFrom: mapView))
            if let tappedPolygon = mapView.polygon(at: mapPoint) {
                onOutlookTap(tappedPolygon)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let overlay = overlay as? OutlookMultiPolygon else { return .init(overlay: overlay) }
        
        let renderer = MKMultiPolygonRenderer(multiPolygon: overlay)
        
        renderer.strokeColor = overlay.strokeColor
        renderer.fillColor = overlay.fillColor
        renderer.lineWidth = 1.0
        
        if overlay.dashed {
            renderer.lineDashPattern = [5, 5]
        }
        
        return renderer
    }
}
