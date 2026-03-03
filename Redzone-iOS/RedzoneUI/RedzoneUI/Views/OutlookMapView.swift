//
//  OutlookMapView.swift
//  RedzoneUI
//
//  Created by Greg Whatley on 9/21/25.
//

import MapKit
import RedzoneCore
import SwiftUI

public struct OutlookMapView: View {
    private let response: OutlookCollection?
    
    @Binding private var position: MapCameraPosition
    @Binding private var mapStyle: MapViewStyle
#if !os(watchOS)
    @Binding private var selection: ResolvedOutlook?
    @Binding private var tappedLocation: CLLocationCoordinate2D?
    
    public init(
        response: OutlookCollection?,
        position: Binding<MapCameraPosition>,
        mapStyle: Binding<MapViewStyle>,
        selection: Binding<ResolvedOutlook?>,
        tappedLocation: Binding<CLLocationCoordinate2D?>
    ) {
        self.response = response
        self._position = position
        self._mapStyle = mapStyle
        self._selection = selection
        self._tappedLocation = tappedLocation
    }
#else
    public init(response: OutlookCollection?, position: Binding<MapCameraPosition>, mapStyle: Binding<MapViewStyle>) {
        self.response = response
        self._position = position
        self._mapStyle = mapStyle
    }
#endif
    
    public var body: some View {
        Map(position: $position) {
            if let groups = response?.groups.sorted(by: { $0.key < $1.key }) {
                ForEach(groups, id: \.key) {
                    ForEach($0.value, id: \.properties.severity) {
                        OutlookPolygon(feature: $0)
                    }
                }
            }
            UserAnnotation(anchor: .center)
#if !os(watchOS)
            if let tappedLocation {
                Marker("Selection", systemImage: "mappin", coordinate: tappedLocation)
            }
#endif
        }
        .mapStyle(mapStyle)
        .mapControlVisibility(.visible)
#if !os(watchOS)
        .mapControls {
            MapScaleView()
        }
        .highPriorityGesture(
            LongPressGesture()
                .onEnded { completed in
                    guard completed else { return }
                    selection = nil
                    tappedLocation = nil
                }
        )
        .onChange(of: response) {
            guard let response,
                  let tappedLocation,
                  let outlook = response.findRisks(at: tappedLocation) else { return }
            selection = outlook
        }
        .mapTapGesture {
            if let outlook = response?.findRisks(at: $0) {
                selection = outlook
                tappedLocation = $0
            } else {
                selection = nil
                tappedLocation = nil
            }
        }
#endif
    }
}
