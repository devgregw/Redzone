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
        OutlookTypePicker()
        
        MapStylePicker()
        
        Toggle(isOn: $autoMoveCamera) {
            Label("Automatically move camera", systemImage: "camera.metering.center.weighted.average")
        }
        
        NavigationLink {
            AboutView()
        } label: {
            Label("About", systemImage: "questionmark.circle")
        }
    }
}
