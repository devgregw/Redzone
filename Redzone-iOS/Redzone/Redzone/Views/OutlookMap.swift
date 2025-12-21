//
//  OutlookMap.swift
//  Redzone
//
//  Created by Greg Whatley on 9/27/25.
//

import CoreLocation
import Dependencies
import MapKit
import RedzoneCore
import RedzoneUI
import SwiftUI

struct OutlookMap: View {
    @CodableAppStorage("selectedOutlookType") private var selectedOutlookType = OutlookType.convective(.day1(.categorical))
    @AppStorage("mapStyle") private var mapStyle: MapViewStyle = .standard
    @Dependency(OutlookService.self) private var outlookService
    @Environment(LocationService.self) private var locationService
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var response: Result<OutlookResponse, any Error>?
    @State private var mapPosition: MapCameraPosition = .unitedStates
    @State private var selectedOutlook: Outlook?
    @State private var sheetState: PersistentSheetState = .collapsed
    @State private var collapsedSheetHeight: CGFloat = .zero
    @State private var tappedLocation: CLLocationCoordinate2D? = .none

    private var currentLocationOutlook: Outlook? {
        guard let location = locationService.lastKnownLocation?.coordinate else { return nil }
        return response?.value?.findOutlook(containing: location)
    }

    private func detailsView(sheet: Bool) -> some View {
        OutlookDetailsView(response: response, selectedOutlook: selectedOutlook ?? currentLocationOutlook, isFromSheet: sheet)
    }

    private var map: some View {
        OutlookMapView(
            response: response?.value,
            position: $mapPosition,
            mapStyle: $mapStyle,
            selection: $selectedOutlook,
            tappedLocation: $tappedLocation
        )
    }

    @ViewBuilder private var mapView: some View {
        if horizontalSizeClass == .compact {
            map
                .persistentSheet(
                    state: $sheetState,
                    collapsedHeight: collapsedSheetHeight,
                    disabled: response == nil || response?.error != nil
                ) {
                    CurrentLocationCollapsedView(response: response, currentLocationOutlook: currentLocationOutlook)
                        .onGeometryChange(for: CGFloat.self, of: \.size.height) {
                            collapsedSheetHeight = $0
                        }
                } expanded: {
                    detailsView(sheet: true)
                }
                .onChange(of: sheetState) {
                    if sheetState == .collapsed {
                        selectedOutlook = nil
                        tappedLocation = nil
                    }
                }
        } else {
            map
                .inspector(isPresented: .constant(true)) {
                    detailsView(sheet: false)
                }
        }
    }

    @MainActor private func fetchOutlook() async {
        do {
            response = nil
            let newResponse = try await outlookService.fetchOutlook(type: selectedOutlookType)
            response = .success(newResponse)
        } catch {
            response = .failure(error)
            selectedOutlook = nil
            tappedLocation = nil
        }
    }

    var body: some View {
        mapView
            .task(id: selectedOutlookType, timeout: 30) {
                await fetchOutlook()
            }
            .onChange(of: selectedOutlook) {
                sheetState = selectedOutlook == nil ? .collapsed : .expanded(detent: .medium)
            }
            .toolbar {
                Button {
                    withAnimation(.interpolatingSpring) {
                        mapPosition = .userLocation(fallback: .unitedStates)
                    }
                    selectedOutlook = nil
                    tappedLocation = nil
                    if horizontalSizeClass == .compact {
                        sheetState = .expanded(detent: .medium)
                    }
                } label: {
                    Image(systemName: "location")
                }

                Button {
                    Task {
                        await fetchOutlook()
                    }
                } label: {
                    if response == nil {
                        ProgressView()
                            .progressViewStyle(.circular)
                    } else {
                        Image(systemName: "arrow.clockwise")
                    }
                }
                .disabled(response == nil)
            }
            .navigationBarBackgroundHidden()
            .navigationTitleSubtitleBackport(title: .redzone, subtitle: selectedOutlookType.localizedStringResource)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarTitleMenu {
                Section {
                    OutlookPicker(selection: $selectedOutlookType)
                    FavoritesPicker(selection: $selectedOutlookType)
                }

                Section {
                    MapStylePicker(mapStyle: $mapStyle)
                }

                Section {
                    NavigationLink {
                        AboutView()
                    } label: {
                        Label("About", systemImage: "questionmark")
                    }
                }
            }
    }
}
