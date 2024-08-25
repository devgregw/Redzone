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
    @Environment(OutlookService.self) private var outlookService
    @Environment(LocationService.self) private var locationService
    @Environment(Context.self) private var context
    
    private var isLoading: Bool {
        outlookService.state == .loading
    }
    
    var outlookFeatures: [OutlookFeature] {
        guard case let .loaded(response) = outlookService.state else {return []}
        return response.features
    }
    
    var currentLocationOutlook: OutlookFeature? {
        guard case let .loaded(response) = outlookService.state,
              let location = locationService.lastKnownLocation?.coordinate else { return nil }
        
        return response
            .features
            .filterNot(by: \.outlookProperties.isSignificant)
            .sorted()
            .reversed()
            .first {
                $0.geometry.lazy.compactCast(to: MKMultiPolygon.self).contains { $0.contains(point: .init(location)) }
            }
    }
    
    var currentLocationSignificant: Bool {
        guard case let .loaded(response) = outlookService.state,
              let location = locationService.lastKnownLocation?.coordinate else { return false }
        
        return response
            .features
            .first(where: \.outlookProperties.isSignificant)?
            .geometry
            .lazy
            .compactCast(to: MKMultiPolygon.self)
            .contains { $0.contains(point: .init(location)) } ?? false
    }
    
    var body: some View {
        NavigationStack {
            @Bindable var context = context
            OutlookMapView(features: outlookFeatures)
                .loading(if: isLoading)
                .animation(.easeInOut.speed(1.25), value: isLoading)
                .sheet(item: $context.selectedOutlook) { outlook in
                    let atCurrentLocation = currentLocationOutlook?.outlookProperties.severity == outlook.highestRisk.properties.severity
                    RiskDetailView(polygon: outlook.highestRisk, isSignificant: outlook.isSignificant, atCurrentLocation: atCurrentLocation)
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
