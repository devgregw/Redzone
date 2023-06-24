//
//  OutlookMap.swift
//  SPC
//
//  Created by Greg Whatley on 3/15/23.
//

import SwiftUI
import MapKit
import SPCCommon

struct OutlookMapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    enum Configuration: String {
        case standard
        case hybrid
        case satellite
        
        private static let poiFilter: MKPointOfInterestFilter = .init(including: [.airport, .hospital, .school, .stadium, .university])
        
        fileprivate var underlyingConfiguration: MKMapConfiguration {
            switch self {
            case .standard:
                let conf = MKStandardMapConfiguration()
                conf.pointOfInterestFilter = Configuration.poiFilter
                return conf
            case .hybrid:
                let conf = MKHybridMapConfiguration()
                conf.pointOfInterestFilter = Configuration.poiFilter
                return conf
            case .satellite: return MKImageryMapConfiguration()
            }
        }
    }
    
    func makeCoordinator() -> OutlookMapViewCoordinator {
        OutlookMapViewCoordinator { [self] strokeHex, significant in
            if let outlook = outlooks?.first(where: \.colors.stroke, equals: strokeHex) {
                tappedOutlook = outlook
            }
        }
    }
    
    var outlooks: [Outlook]?
    @Binding var userLocation: MKUserLocation
    @Binding var tappedOutlook: Outlook?
    @Binding var selectedConfiguration: Configuration
    
    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView(frame: .zero)
        view.delegate = context.coordinator
        view.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.mapView(gestureRecognized:))))
        view.showsUserLocation = true
        view.preferredConfiguration = selectedConfiguration.underlyingConfiguration
        return view
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let outlooks {
            uiView.removeOverlays(uiView.overlays)
            uiView.addOverlays(context.coordinator.getZonePolygons(from: outlooks), level: .aboveRoads)
            uiView.addOverlays(context.coordinator.getSignificantPolygons(from: outlooks), level: .aboveLabels)
            context.coordinator.updatedCache(for: outlooks)
        } else {
            uiView.removeOverlays(uiView.overlays)
            context.coordinator.resetCache()
        }
        
        uiView.preferredConfiguration = selectedConfiguration.underlyingConfiguration
        
        Task {
            userLocation = uiView.userLocation
        }
    }
}
