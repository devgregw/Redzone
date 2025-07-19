//
//  ContentView.swift
//  Redzone
//
//  Created by Greg Whatley on 3/15/23.
//

import CoreLocation
import MapKit
import SwiftUI
import GeoJSON

struct ContentView: View {
    @CodedAppStorage(AppStorageKeys.outlookType) private var outlookType: OutlookType = Context.defaultOutlookType
    @AppStorage(AppStorageKeys.mapStyle) private var mapStyle: MapViewStyle = .standard
    @AppStorage(AppStorageKeys.autoMoveCamera) private var autoMoveCamera = true
#if DEBUG
    @AppStorage(AppStorageKeys.useMockData) private var useMockData: Bool = false
#endif
    @Environment(OutlookService.self) private var outlookService
    @Environment(LocationService.self) private var locationService
    @Environment(Context.self) private var context
    
    var outlookFeatures: [GeoJSONFeature] {
        guard case let .loaded(response) = outlookService.state else {return []}
        return response.features
    }
    
    var currentLocationOutlook: GeoJSONFeature? {
        guard case let .loaded(response) = outlookService.state,
              let location = locationService.lastKnownLocation?.coordinate else { return nil }
        
        return response
            .features
            .filter(\.outlookProperties.isSignificant.not)
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
        @Bindable var context = context
        NavigationStack {
            OutlookMapView(features: outlookFeatures)
                .toolbar {
                    MainToolbar()
                }
                .navigationTitle(outlookType.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarTitleMenu {
                    ToolbarMenu()
                }
                .navigationBarBackgroundHidden()
                .safeAreaInset(edge: .bottom) {
                    CurrentLocationButton(highestRisk: currentLocationOutlook, isSignificant: currentLocationSignificant)
                }
                .loading(if: outlookService.state == .loading)
                .sheet(item: $context.selectedOutlook) { outlook in
                    let atCurrentLocation = currentLocationOutlook?.outlookProperties.severity == outlook.highestRisk.outlookProperties.severity
                    RiskDetailView(feature: outlook.highestRisk, isSignificant: outlook.isSignificant, atCurrentLocation: atCurrentLocation)
                }
                .sheet(isPresented: $context.displayFavoritesSheet) {
                    FavoritesManagerView()
                }
            #if DEBUG
                .task(id: [outlookType.hashValue, useMockData.hashValue], fetchOutlook)
            #else
                .task(id: outlookType, fetchOutlook)
            #endif
        }
    }
    
    private func fetchOutlook() async {
        await outlookService.load(outlookType)
        if autoMoveCamera {
            context.moveCamera(centering: outlookService.state)
        }
    }
}
