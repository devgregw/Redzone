//
//  ToolbarMenu.swift
//  Redzone
//
//  Created by Greg Whatley on 6/15/25.
//

import SwiftUI

struct ToolbarMenu: View {
    @AppStorage(AppStorageKeys.autoMoveCamera) private var autoMoveCamera = true
    
    var body: some View {
        Section {
            OutlookTypePicker()
            FavoritesPicker()
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
                Text("Version \(Bundle.main.versionString)")
            }
        }
    }
}
