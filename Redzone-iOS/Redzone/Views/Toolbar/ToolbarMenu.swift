//
//  ToolbarMenu.swift
//  Redzone
//
//  Created by Greg Whatley on 6/15/25.
//

import SwiftUI

struct ToolbarMenu: View {
    @AppStorage(AppStorageKeys.autoMoveCamera) private var autoMoveCamera = true
#if DEBUG
    @AppStorage(AppStorageKeys.useMockData) private var useMockData = false
#endif
    
    var body: some View {
        Section {
            OutlookTypePicker()
            FavoritesPicker()
#if DEBUG
            Toggle("Use mock data", systemImage: "ladybug", isOn: $useMockData)
#endif
        }
        
        Section {
            MapStylePicker()
            
            Toggle(isOn: $autoMoveCamera) {
                Label("Automatically Move Camera", systemImage: "camera.metering.center.weighted.average")
            }
        }
        
        Section {
            NavigationLink {
                AboutView()
            } label: {
                Label("About", systemImage: "questionmark.circle")
#if DEBUG
                Text("Version \(Bundle.main.versionString) DEBUG")
#else
                Text("Version \(Bundle.main.versionString)")
#endif
            }
        }
    }
}
