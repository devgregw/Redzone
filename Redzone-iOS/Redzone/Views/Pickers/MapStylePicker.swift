//
//  MapStylePicker.swift
//  Redzone
//
//  Created by Greg Whatley on 7/10/23.
//

import SwiftUI

struct MapStylePicker: View {
    @AppStorage(AppStorageKeys.mapStyle) private var mapStyle: MapViewStyle = .standard
    
    var body: some View {
        Picker(selection: $mapStyle) {
            ForEach(MapViewStyle.allCases, id: \.self) {
                Text($0.rawValue.capitalized)
            }
            .foregroundStyle(.secondary)
        } label: {
            Label("Map Style", systemImage: "map")
            Text(mapStyle.rawValue.capitalized)
        }
        .menuOrder(.fixed)
        .pickerStyle(.menu)
    }
}

#Preview {
    MapStylePicker()
}
