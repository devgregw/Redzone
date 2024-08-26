//
//  ContentView.swift
//  SPCMap
//
//  Created by Greg Whatley on 3/15/23.
//

import CoreLocation
import MapKit
import SwiftUI
import GeoJSON

struct ContentView: View {
    @Environment(OutlookService.self) private var outlookService
    @Environment(LocationService.self) private var locationService
    @Environment(Context.self) private var context
    
    private var isLoading: Bool {
        outlookService.state == .loading
    }
    
    var outlookFeatures: [GeoJSONFeature] {
        guard case let .loaded(response) = outlookService.state else {return []}
        return response.features
    }
    
    var currentLocationOutlook: GeoJSONFeature? {
        guard case let .loaded(response) = outlookService.state,
              let location = locationService.lastKnownLocation?.coordinate else { return nil }
        
        return response
            .features
            .filterNot(by: \.outlookProperties.isSignificant)
            .lazy
            .sorted()
            .reversed()
            .first {
                $0.multiPolygon?.contains(point: location) ?? false
            }
    }
    
    var currentLocationSignificant: Bool {
        guard case let .loaded(response) = outlookService.state,
              let location = locationService.lastKnownLocation?.coordinate else { return false }
        
        return response
            .features
            .first(where: \.outlookProperties.isSignificant)?
            .multiPolygon?
            .contains(point: location) ?? false
    }
    
    var body: some View {
        NavigationStack {
            @Bindable var context = context
            OutlookMapView(features: outlookFeatures)
                .loading(if: isLoading)
                .animation(.easeInOut.speed(1.25), value: isLoading)
                .sheet(item: $context.selectedOutlook) { outlook in
                    let atCurrentLocation = currentLocationOutlook?.outlookProperties.severity == outlook.highestRisk.outlookProperties.severity
                    RiskDetailView(feature: outlook.highestRisk, isSignificant: outlook.isSignificant, atCurrentLocation: atCurrentLocation)
                }
                .toolbar(.hidden, for: .navigationBar)
        }
        .onChange(of: context.outlookType, initial: true) {
            await outlookService.load(context.outlookType)
            if Settings.autoMoveCamera {
                context.moveCamera(centering: outlookService.state)
            }
        }
        .toolbar {
            BottomToolbar(highestRisk: currentLocationOutlook, isSignificant: currentLocationSignificant)
        }
    }
}

#Preview {
    ContentView()
        .environment(OutlookService())
        .environment(Context())
}
