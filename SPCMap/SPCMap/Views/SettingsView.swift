//
//  SettingsView.swift
//  SPCMap
//
//  Created by Greg Whatley on 6/16/23.
//

import SwiftUI
import CoreLocationUI

struct SettingsView: View {
    @Environment(LocationService.self) private var locationService
    @Environment(Context.self) private var context
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    OutlookTypePicker()
                    MapStylePicker()
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
