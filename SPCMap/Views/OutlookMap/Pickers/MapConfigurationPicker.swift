//
//  MapConfigurationPicker.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/8/23.
//

import SwiftUI

struct MapConfigurationPicker: View {
    @Binding var mapConfig: OutlookMapView.Configuration
    
    var body: some View {
        Menu {
            Button("Standard") { mapConfig = .standard }
            Button("Hybrid") { mapConfig = .hybrid }
            Button("Satellite") { mapConfig = .satellite }
        } label: {
            Image(systemName: "map")
                .imageScale(.large)
        }
    }
}
