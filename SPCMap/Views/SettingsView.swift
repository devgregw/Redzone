//
//  SettingsView.swift
//  SPCMap
//
//  Created by Greg Whatley on 6/16/23.
//

import SwiftUI

struct SettingsView: View {
    @Binding var selectedOutlook: OutlookType
    @Binding var selectedMapStyle: OutlookMapView.Configuration
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    OutlookPicker(selection: $selectedOutlook)
                    
                    Picker(selection: $selectedMapStyle) {
                        ForEach(OutlookMapView.Configuration.allCases, id: \.self) {
                            Text($0.rawValue.capitalized)
                        }
                        .foregroundStyle(.secondary)
                    } label: {
                        Label("Map Style", systemImage: "map")
                    }
                    .menuOrder(.fixed)
                    .pickerStyle(.menu)
                }
                
                Section {
                    NavigationLink {
                        AboutView()
                    } label: {
                        Label("About", systemImage: "questionmark.circle")
                    }
                }
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
