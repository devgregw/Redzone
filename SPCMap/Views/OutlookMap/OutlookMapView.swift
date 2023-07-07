//
//  OutlookMap.swift
//  SPCMap
//
//  Created by Greg Whatley on 3/15/23.
//

import SwiftUI
import MapKit

struct OutlookMapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    enum Configuration: String, Identifiable, CaseIterable {
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
        
        var id: String {
            rawValue
        }
    }
    
    func makeCoordinator() -> OutlookMapViewCoordinator {
        OutlookMapViewCoordinator { self.tappedOutlook = $0 }
    }
    
    var features: [OutlookFeature]?
    @Binding var userLocation: MKUserLocation
    @Binding var selectedConfiguration: Configuration
    
    @Binding var tappedOutlook: TappedOutlook?
    
    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView(frame: .zero)
        view.delegate = context.coordinator
        view.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.mapView(gestureRecognized:))))
        view.showsUserLocation = true
        view.preferredConfiguration = selectedConfiguration.underlyingConfiguration
        return view
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let features {
            uiView.removeOverlays(uiView.overlays)
            uiView.addOverlays(features.flatMap { f in f.geometry.compactMap { g in g as? MKMultiPolygon } })
        } else {
            uiView.removeOverlays(uiView.overlays)
        }
        
        uiView.preferredConfiguration = selectedConfiguration.underlyingConfiguration
        
        Task {
            userLocation = uiView.userLocation
        }
    }
}
