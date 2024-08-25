//
//  OutlookMapView.swift
//  SPCMap
//
//  Created by Greg Whatley on 7/6/23.
//

import MapKit
import SwiftUI

struct OutlookMapView: View {
    enum Style: String, CaseIterable {
        case standard
        case hybrid
        case satellite
    }
    
    @Environment(Context.self) private var context
    
    let features: [OutlookFeature]?
    private let coordinateSpace: NamedCoordinateSpace = .named("Map")
    
    var body: some View {
        MapReader { proxy in
            @Bindable var context = context
            Map(position: $context.mapCameraPosition) {
                if let features {
                    ForEach(features, id: \.id) { feature in
                        ForEach(feature.multiPolygons, id: \.hashValue) { multiPolygon in
                            MapMultiPolygon(multiPolygon: multiPolygon)
                        }
                    }
                }
                UserAnnotation(anchor: .center)
            }
            .coordinateSpace(coordinateSpace)
            .onTapGesture { point in
                if let coordinate = proxy.convert(point, from: coordinateSpace) {
                    Logger.log(.map, "Tap gesture @ (x: \(point.x), y: \(point.y)) mapped to coordinate (lat: \(coordinate.latitude), lon: \(coordinate.longitude))")
                    context.selectedOutlook = features?.findTappedOutlook(at: coordinate)
                }
            }
            .mapControls {
                MapScaleView()
            }
            .mapControlVisibility(.visible)
            .mapStyle(context.mapStyle)
        }
    }
}
