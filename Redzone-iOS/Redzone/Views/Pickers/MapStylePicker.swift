//
//  MapStylePicker.swift
//  Redzone
//
//  Created by Greg Whatley on 7/10/23.
//

import SwiftUI

struct MapStylePicker: View {
    @Environment(Context.self) private var context
    
    var body: some View {
        @Bindable var context = context
        Picker(selection: $context.mapStyle) {
            ForEach(MapViewStyle.allCases, id: \.self) {
                Text($0.rawValue.capitalized)
            }
            .foregroundStyle(.secondary)
        } label: {
            Label("Map Style", systemImage: "map")
        }
        .menuOrder(.fixed)
        .pickerStyle(.menu)
    }
}

#Preview {
    MapStylePicker()
        .environment(Context())
}
