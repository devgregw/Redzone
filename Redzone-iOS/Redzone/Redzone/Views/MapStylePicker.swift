//
//  MapStylePicker.swift
//  Redzone
//
//  Created by Greg Whatley on 10/18/25.
//

import RedzoneUI
import SwiftUI

struct MapStylePicker: View {
    @Binding var mapStyle: MapViewStyle

    var body: some View {
        ControlGroupPicker(.mapStyle, selection: $mapStyle) {
            ForEach(MapViewStyle.allCases, id: \.self) {
                Label($0.localizedStringResource, systemImage: $0.systemImage)
            }
        }
    }
}
