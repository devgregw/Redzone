//
//  OutlookMapView.swift
//  Redzone
//
//  Created by Greg Whatley on 7/6/23.
//

import MapKit
import SwiftUI
import GeoJSON

struct OutlookMapView: View {
    @AppStorage(AppStorageKeys.mapStyle) private var mapStyle: MapViewStyle = .standard
    @Environment(Context.self) private var context
    
    let features: [GeoJSONFeature]?
    
    var body: some View {
        MapReader { proxy in
            @Bindable var context = context
            Map(position: $context.mapCameraPosition) {
                if let features {
                    ForEach(features, id: \.id) { feature in
                        if let multiPolygon = feature.multiPolygon {
                            MapMultiPolygon(multiPolygon: multiPolygon, properties: feature.outlookProperties)
                        }
                    }
                }
                UserAnnotation(anchor: .center)
            }
            .highPriorityGesture(SpatialTapGesture(coordinateSpace: .global).onEnded {
                let point = $0.location
                if let coordinate = proxy.convert(point, from: .global) {
                    Logger.log(.map, "Tap gesture @ (x: \(point.x), y: \(point.y)) mapped to coordinate (lat: \(coordinate.latitude), lon: \(coordinate.longitude))")
                    context.selectedOutlook = features?.findTappedOutlook(at: coordinate)
                }
            })
            .mapControls {
                MapScaleView()
            }
            .mapControlVisibility(.visible)
            .mapStyle(mapStyle)
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(Material.bar)
                    .frame(height: 150)
                    .mask {
                        LinearGradient(colors: [.black, .clear], startPoint: .top, endPoint: .bottom)
                    }
                    .ignoresSafeArea()
            }
        }
    }
}
