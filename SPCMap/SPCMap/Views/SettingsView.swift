//
//  SettingsView.swift
//  SPCMap
//
//  Created by Greg Whatley on 6/16/23.
//

import SwiftUI
import CoreLocationUI

struct SettingsView: View {
    @State private var autoMoveCamera: Bool = Settings.autoMoveCamera
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    OutlookTypePicker()
                    MapStylePicker()
                }
                
                Section {
                    Toggle(isOn: $autoMoveCamera) {
                        Label("Automatically move camera", systemImage: "camera.metering.center.weighted.average")
                    }
                    .onChange(of: autoMoveCamera) {
                        Settings.autoMoveCamera = autoMoveCamera
                    }
                }
                
                Section {
                    NavigationLink {
                        AboutView()
                    } label: {
                        Label("About", systemImage: "questionmark.circle")
                    }
                }
            }
            .toolbar {
                DismissButton()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .scrollContentBackground(.hidden)
        .presentationBackground(.thinMaterial)
        .presentationDetents([.fraction(0.3), .medium, .large])
        .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.3)))
        .presentationDragIndicator(.visible)
    }
}
