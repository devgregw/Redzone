//
//  OutlookMapViewCoordinator.swift
//  SPC
//
//  Created by Greg Whatley on 4/7/23.
//

import SwiftUI
import MapKit
import SPCCommon

class OutlookMapViewCoordinator: NSObject {
    private var outlookCache: Int = -1
    private var zonePolygonCache: [MKMultiPolygon] = []
    private var sigPolygonCache: [MKPolygon] = []
    
    private func generateData(from outlook: Outlook?) -> String? {
        if let outlook {
            return outlook.isSignificant ? ",,true" : "\(outlook.colors.stroke),\(outlook.colors.fill),false"
        } else {
            return nil
        }
    }
    
    private func makePolygon(from outlookPolygon: Outlook.Polygon, outlook: Outlook?, interiorPolygons: [MKPolygon]?) -> MKPolygon {
        return MKPolygon(coordinates: outlookPolygon, interiorPolygons: interiorPolygons, data: generateData(from: outlook))
    }
    
    let onOutlookTap: (String, Bool) -> Void
    
    init(onOutlookTap: @escaping (String, Bool) -> Void) {
        self.onOutlookTap = onOutlookTap
    }
    
    func cacheIsApplicable(forRequestedOutlooks outlooks: [Outlook]) -> Bool {
        outlookCache != outlooks.hashValue
    }
    
    func resetCache() {
        outlookCache = -1
        zonePolygonCache = []
        sigPolygonCache = []
    }
    
    func updatedCache(for selectedOutlooks: [Outlook]) {
        outlookCache = selectedOutlooks.hashValue
    }
    
    func getZonePolygons(from selectedOutlooks: [Outlook]) -> [MKMultiPolygon] {
        guard cacheIsApplicable(forRequestedOutlooks: selectedOutlooks) else {
            return zonePolygonCache
        }
        
        let outlooks = selectedOutlooks.filterNot(by: \.isSignificant)
        var output: [MKMultiPolygon] = []
        for (idx, outlook) in outlooks.enumerated() {
            var currentPolygons = outlook.polygons
            var interiorPolygons: [MKPolygon] = []
            if idx + 1 < outlooks.count {
                let nextPolygons = outlooks[idx + 1].polygons
                let intersection = currentPolygons.filter { a in nextPolygons.contains { b in a.polygonHashValue == b.polygonHashValue } }
                interiorPolygons = intersection.map {
                    makePolygon(from: $0, outlook: nil, interiorPolygons: nil)
                }
                
                currentPolygons.removeAll { a in intersection.contains { b in a.polygonHashValue == b.polygonHashValue } }
            }
            
            let zone = MKMultiPolygon(currentPolygons.map {
                makePolygon(from: $0, outlook: outlook, interiorPolygons: interiorPolygons)
            })
            zone.accessibilityLabel = generateData(from: outlook)
            
            output.append(zone)
        }
        
        zonePolygonCache = output
        return output
    }
    
    func getSignificantPolygons(from selectedOutlooks: [Outlook]) -> [MKPolygon] {
        guard cacheIsApplicable(forRequestedOutlooks: selectedOutlooks) else {
            return sigPolygonCache
        }
        
        if let outlook = selectedOutlooks.first(where: \.isSignificant) {
            sigPolygonCache = outlook.polygons.map {
                makePolygon(from: $0, outlook: outlook, interiorPolygons: nil)
            }
        } else {
            sigPolygonCache = []
        }
        
        return sigPolygonCache
    }
}

extension OutlookMapViewCoordinator: MKMapViewDelegate {
    private func createRenderer(for overlay: MKOverlay) -> (renderer: MKOverlayPathRenderer, data: String)? {
        if let polygon = overlay as? MKPolygon, let data = polygon.accessibilityLabel {
            return (renderer: MKPolygonRenderer(polygon: polygon), data: data)
        } else if let polygon = overlay as? MKMultiPolygon, let data = polygon.accessibilityLabel {
            return (renderer: MKMultiPolygonRenderer(multiPolygon: polygon), data: data)
        } else {
            return nil
        }
    }
    
    @objc func mapView(gestureRecognized tap: UITapGestureRecognizer) {
        if let mapView = tap.view as? MKMapView, tap.state == .recognized {
            let tapLocation = tap.location(in: mapView)
            let mapPoint = MKMapPoint(mapView.convert(tapLocation, toCoordinateFrom: mapView))
            if let (tappedPolygon, significant) = mapView.polygon(at: mapPoint),
               let strokeColorHex = tappedPolygon.accessibilityLabel?.split(separator: ",").first {
                onOutlookTap("\(strokeColorHex)", significant)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let (renderer, data) = createRenderer(for: overlay) else {
            return .init(overlay: overlay)
        }
        
        let components = data.split(separator: ",", omittingEmptySubsequences: false).map(String.init(_:))
        let isSignificant = components[2] == "true"
        
        renderer.strokeColor = isSignificant ? .black : .init(hex: components[0])
        renderer.fillColor = isSignificant ? .clear : (.init(hex: components[1]).withAlphaComponent(0.25))
        renderer.lineWidth = 1.0
        
        if isSignificant {
            renderer.lineDashPattern = [5, 5]
        }
        
        return renderer
    }
}
