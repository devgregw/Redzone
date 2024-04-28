//
//  Context.swift
//  SPCMap
//
//  Created by Greg Whatley on 7/10/23.
//

import SwiftUI
import MapKit

@Observable
class Context {
    static let defaultOutlookType: OutlookType = .convective1(.categorical)
    
    var outlookType: OutlookType = Context.defaultOutlookType
    var mapStyle: OutlookMapView.Style = .standard
    var selectedOutlook: TappedOutlook? = nil {
        didSet {
            Logger.log(.map, "Tapped outlook: \(selectedOutlook?.highestRisk.properties.title ?? "nil")")
            displaySettingsSheet = false
        }
    }
    var displaySettingsSheet: Bool = false
    var mapCameraPosition: MapCameraPosition = .automatic
    
    func moveCamera(to coordinate: CLLocationCoordinate2D) {
        Logger.log(.map, "Moving camera to coordinate (lat: \(coordinate.latitude), \(coordinate.longitude))")
        withAnimation {
            mapCameraPosition = .region(.init(center: coordinate, latitudinalMeters: 80_000, longitudinalMeters: 80_000))
        }
    }
    
    func moveCamera(centering state: OutlookService.State) {
        guard case let .loaded(response) = state else { return }
        let mapRects = response.features.flatMap { $0.multiPolygons.map { $0.boundingMapRect } }
        guard let largestRect = mapRects.max() else { return }
        Logger.log(.map, "Moving camera to rect (midX: \(largestRect.midX), midY: \(largestRect.midY), width: \(largestRect.width), height: \(largestRect.height))")
        withAnimation {
            mapCameraPosition = .rect(largestRect)
        }
    }
}
