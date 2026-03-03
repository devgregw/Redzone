//
//  ContentView.swift
//  RedzoneWatch Watch App
//
//  Created by Greg Whatley on 9/21/25.
//

import Dependencies
import MapKit
import RedzoneCore
import RedzoneUI
import SwiftUI

struct MapView: View {
    let outlookCollection: OutlookCollection?
    @State private var position: MapCameraPosition = .unitedStates

    var body: some View {
        OutlookMapView(response: outlookCollection, position: $position, mapStyle: .constant(.standard))
            .overlay {
                if outlookCollection == nil {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(width: 48, height: 48)
                        .background {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .stroke(.separator)
                        }
                        .transition(.blurReplace)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Location", systemImage: "location") {
                        withAnimation(.interpolatingSpring) {
                            position = .userLocation(fallback: .unitedStates)
                        }
                    }
                }
            }
            .navigationTitle("Map")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContentView: View {
    @CodableAppStorage("selectedOutlookType") private var selectedOutlookType = OutlookType.convective(.day1(.categorical))
    @Dependency(OutlookService.self) private var outlookService
    @Environment(LocationService.self) private var locationService
    @State private var outlookCollection: OutlookCollection?

    struct PercentageRiskView: View {
        @Dependency(OutlookService.self) private var outlookService
        @State private var response: OutlookCollection?
        let request: Convective.Classification
        let factory: (Convective.Classification) -> OutlookType
        let image: String
        let location: CLLocationCoordinate2D

        var outlook: ResolvedOutlook? {
            response?.findRisks(at: location)
        }

        var title: String {
            outlook?[.convectivePrimary]?.properties.title ?? "No forecasted risk"
        }

        var isSignificant: Bool {
            outlook?[.convectiveCIG] != nil
        }

        var body: some View {
            Label(title, systemImage: isSignificant ? "exclamationmark.triangle.fill" : image)
                .symbolRenderingMode(isSignificant ? .multicolor : .monochrome)
                .task(id: request, timeout: 30) {
                    response = try? await outlookService.fetchOutlook(type: factory(request))
                }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                if let outlookCollection {
                    if let location = locationService.lastKnownLocation?.coordinate {
                        if let feature = outlookCollection.findRisks(at: location)?[.convectivePrimary] {
                            ScrollView {
                                VStack {
                                    CategoricalGaugeView(properties: feature.properties)
                                    Text(feature.properties.title)
                                        .font(.headline)
                                    Text(selectedOutlookType.localizedStringResource)
                                        .font(.footnote)

                                    Divider()
                                        .padding(.vertical)

                                    if feature.properties.severity > .generalThunder,
                                       selectedOutlookType != .convective(.day3(probabilistic: false)) {
                                        VStack(alignment: .leading) {
                                            PercentageRiskView(
                                                request: .wind,
                                                factory: { .convective(.day2($0)) },
                                                image: "wind",
                                                location: location
                                            )
                                            PercentageRiskView(
                                                request: .hail,
                                                factory: { .convective(.day2($0)) },
                                                image: "cloud.hail",
                                                location: location
                                            )
                                            PercentageRiskView(
                                                request: .tornado,
                                                factory: { .convective(.day2($0)) },
                                                image: "tornado",
                                                location: location
                                            )
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }
                        } else {
                            Image(systemName: "sparkles")
                                .symbolRenderingMode(.multicolor)
                                .font(.title)
                            Text(.noRisk)
                                .font(.subheadline.weight(.medium))
                        }
                    } else {
                        Image(systemName: "location.slash.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title)
                        Text(.locationDisabled)
                            .font(.subheadline.weight(.medium))
                    }
                } else {
                    ProgressView()
                        .frame(width: 48, height: 48)
                        .progressViewStyle(.circular)
                        .transition(.blurReplace)
                }
            }
            .navigationTitle("Redzone")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink {
                        Picker("Outlook", systemImage: "binoculars", selection: $selectedOutlookType) {
                            Text("Day 1")
                                .tag(OutlookType.convective(.day1(.categorical)))
                            Text("Day 2")
                                .tag(OutlookType.convective(.day2(.categorical)))
                            Text("Day 3")
                                .tag(OutlookType.convective(.day3(probabilistic: false)))
                        }
                        .pickerStyle(.wheel)
                    } label: {
                        Label("Outlook", systemImage: "binoculars")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink {
                        MapView(outlookCollection: outlookCollection)
                    } label: {
                        Label("Map", systemImage: "map")
                    }
                }
            }
            .task(id: selectedOutlookType, timeout: 30) {
                outlookCollection = try? await outlookService.fetchOutlook(type: selectedOutlookType)
            }
        }
    }
}
