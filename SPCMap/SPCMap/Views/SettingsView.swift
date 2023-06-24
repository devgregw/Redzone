//
//  SettingsView.swift
//  SPC
//
//  Created by Greg Whatley on 6/16/23.
//

import SwiftUI

struct SettingsView: View {
    @Binding private var selectedOutlookType: String
    @Binding private var timeFrame: Int
    
    init(selectedOutlookType: Binding<String>, timeFrame: Binding<Int>) {
        self._selectedOutlookType = selectedOutlookType
        self._timeFrame = timeFrame
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker(selection: .constant("Severe")) {
                        ForEach(["Severe", "Thunderstorm", "Fire"], id: \.self) {
                            Text($0)
                        }
                    } label: {
                        Label("Outlook", systemImage: "sun.max.trianglebadge.exclamationmark")
                            .symbolRenderingMode(.multicolor)
                    }
                    
                    OutlookPicker(selectedOutlookType: $selectedOutlookType, timeFrame: timeFrame)
                    
                    Picker(selection: $timeFrame) {
                        ForEach(1...3, id: \.self) {
                            Text("Day \($0)")
                        }
                    } label: {
                        Label("Timeframe", systemImage: "clock")
                            .symbolRenderingMode(.multicolor)
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
