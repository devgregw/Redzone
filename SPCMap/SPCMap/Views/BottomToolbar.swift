//
//  BottomToolbar.swift
//  SPC
//
//  Created by Greg Whatley on 4/8/23.
//

import SwiftUI
import SPCCommon

struct BottomToolbar: ToolbarContent {
    let highestRisk: Outlook?
    let isSignificant: Bool
    @Binding var timeFrame: Int
    @Binding var selectedOutlookType: String
    
    init(highestRisk: Outlook?, isSignificant: Bool, timeFrame: Binding<Int>, selectedOutlookType: Binding<String>) {
        self.highestRisk = highestRisk
        self.isSignificant = isSignificant
        self._timeFrame = timeFrame
        self._selectedOutlookType = selectedOutlookType
    }
    
    @EnvironmentObject private var outlookService: OutlookService
    
    @State private var displayDetail: Bool = false
    @State private var displaySettings: Bool = false
    
    var body: some ToolbarContent {
        Button {
            displayDetail.toggle()
        } label: {
            HStack(alignment: .center) {
                if let highestRisk {
                    Image(systemName: "circle")
                        .symbolRenderingMode(.monochrome)
                        .foregroundColor(highestRisk.colors.strokeColor)
                }
                
                Text(highestRisk?.name ?? "No risk zones at your location")
                    .font(.callout)
                
                if isSignificant {
                    SigSevereBadgeView(theme: .light, font: .caption)
                }
            }
        }
        .disabled(highestRisk == nil)
        .buttonStyle(.plain)
        .sheet(isPresented: $displayDetail) {
            if let highestRisk {
                RiskDetailView(outlook: highestRisk, isSignificant: isSignificant, atCurrentLocation: true, selectedType: selectedOutlookType, timeFrame: timeFrame)
            }
        }
        
        .sheet(isPresented: $displaySettings) {
            SettingsView(selectedOutlookType: $selectedOutlookType, timeFrame: $timeFrame)
        }
        .toolbarItem(.bottomBar)
        
        Spacer()
            .toolbarItem(.bottomBar)
        
        Button {
            outlookService.loadTask(rawSelection: timeFrame)
        } label: {
            Image(systemName: "arrow.clockwise")
        }
        .toolbarItem(.bottomBar)
        
        Button {
            displaySettings.toggle()
        } label: {
            Image(systemName: "square.3.layers.3d")
        }
        .toolbarItem(.bottomBar)
    }
}
