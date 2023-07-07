//
//  ContentView.swift
//  SPCMap
//
//  Created by Greg Whatley on 3/15/23.
//

import CoreLocation
import MapKit
import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var outlookService: OutlookService
    
    @State private var userLocation: MKUserLocation = .init()
    @State private var selectedOutlook: OutlookType = .convective1(.categorical)
    @State private var tappedOutlook: TappedOutlook? = nil
    @State private var mapConfig: OutlookMapView.Configuration = .standard
    @State private var displaySettings: Bool = false
    
    private let locationManager: CLLocationManager = .init()
    
    private var isLoading: Bool {
        outlookService.state == .loading
    }
    
    var outlookFeatures: [OutlookFeature] {
        guard case let .loaded(response) = outlookService.state else {return []}
        return response.features
    }
    
    var currentLocationOutlook: OutlookFeature? {
        guard case let .loaded(response) = outlookService.state else { return nil }
        
        return response
            .features
            .filterNot(by: \.outlookProperties.isSignificant)
            .sorted()
            .first {
                $0.geometry.lazy.compactCast(to: MKMultiPolygon.self).contains { $0.contains(point: .init(userLocation.coordinate)) }
            }
    }
    
    var currentLocationSignificant: Bool {
        guard case let .loaded(response) = outlookService.state else { return false }
        
        return response
            .features
            .first(where: \.outlookProperties.isSignificant)?
            .geometry
            .lazy
            .compactCast(to: MKMultiPolygon.self)
            .contains { $0.contains(point: .init(userLocation.coordinate)) } ?? false
    }
    
    /* @ViewBuilder private var buttonBar: some View {
        if locationManager.authorizationStatus != .authorizedWhenInUse {
            Button {
                locationManager.requestWhenInUseAuthorization()
            } label: {
                Image(systemName: "location")
                    .padding(12)
                    .imageScale(.large)
            }
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    } */
    
    var body: some View {
        NavigationStack {
            OutlookMapView(features: outlookFeatures, userLocation: $userLocation, selectedConfiguration: $mapConfig, tappedOutlook: $tappedOutlook)
                .edgesIgnoringSafeArea(.vertical)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .loading(if: isLoading)
                .animation(.easeInOut.speed(1.25), value: isLoading)
                .sheet(item: $tappedOutlook) { outlook in
                    let atCurrentLocation = currentLocationOutlook?.outlookProperties.severity == outlook.highestRisk.properties.severity
                    RiskDetailView(polygon: outlook.highestRisk, isSignificant: outlook.isSignificant, atCurrentLocation: atCurrentLocation, selectedOutlook: selectedOutlook)
                }
        }
        .task {
            await outlookService.load(selectedOutlook)
        }
        .toolbar {
            BottomToolbar(highestRisk: currentLocationOutlook, isSignificant: currentLocationSignificant, selectedOutlook: $selectedOutlook, selectedMapStyle: $mapConfig, displaySettings: $displaySettings)
        }
        .onChange(of: tappedOutlook) { newValue in
            if !newValue.isNil {
                displaySettings = false
            }
        }
        .onChange(of: selectedOutlook) { newValue in
            Task { await outlookService.load(newValue) }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(OutlookService())
    }
}
