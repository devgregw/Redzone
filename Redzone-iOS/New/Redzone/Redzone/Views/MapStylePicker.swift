//
//  MapStylePicker.swift
//  Redzone
//
//  Created by Greg Whatley on 10/18/25.
//

import SwiftUI
import RedzoneUI

struct MapStylePicker: View {
    @Binding var mapStyle: MapViewStyle

    var body: some View {
        Picker(selection: $mapStyle) {
            ForEach(MapViewStyle.allCases, id: \.self) {
                Text($0.localizedStringResource)
            }
        } label: {
            Label("Map Style", systemImage: "map")
            Text(mapStyle.localizedStringResource)
        }
        .pickerStyle(.menu)
    }
}
