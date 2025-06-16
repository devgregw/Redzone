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
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            if !locationService.isUpdatingLocation {
                                locationService.requestPermission()
                            } else if let location = locationService.lastKnownLocation?.coordinate {
                                context.moveCamera(to: location)
                            }
                        } label: {
                            Image(systemName: "location\(locationService.isUpdatingLocation ? ".fill" : "")")
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            await outlookService.refresh()
                            if await autoMoveCamera {
                                await self.context.moveCamera(centering: outlookService.state)
                            }
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                        .disabled(isLoading)
                    }
                }
                .navigationTitle("\(outlookType.subSection) • Day \(outlookType.day)")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarTitleMenu {
                    OutlookTypePicker()
                    Picker(selection: $mapStyle) {
                        ForEach(MapViewStyle.allCases, id: \.self) {
                            Text($0.rawValue.capitalized)
                        }
                        .foregroundStyle(.secondary)
                    } label: {
                        Label("Map Style", systemImage: "map")
                    }
                    .menuOrder(.fixed)
                    .pickerStyle(.menu)
                    Toggle(isOn: $autoMoveCamera) {
                        Label("Automatically move camera", systemImage: "camera.metering.center.weighted.average")
                    }
                    NavigationLink {
                        AboutView()
                    } label: {
                        Label("About", systemImage: "questionmark.circle")
                    }
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    CurrentLocationButton(highestRisk: currentLocationOutlook, isSignificant: currentLocationSignificant)
                }
                .loading(if: isLoading)
                .sheet(item: $context.selectedOutlook) { outlook in
                    let atCurrentLocation = currentLocationOutlook?.outlookProperties.severity == outlook.highestRisk.outlookProperties.severity
                    RiskDetailView(feature: outlook.highestRisk, isSignificant: outlook.isSignificant, atCurrentLocation: atCurrentLocation)
                }
                .task(id: outlookType) {
                    await outlookService.load(outlookType)
                    if autoMoveCamera {
                        context.moveCamera(centering: outlookService.state)
                    }
                }
        }
    }
}
