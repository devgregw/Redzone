//
//  BottomToolbar.swift
//  SPC
//
//  Created by Greg Whatley on 4/8/23.
//

import SwiftUI

struct CurrentLocationButton: View {
    @EnvironmentObject private var outlookService: OutlookService
    @State private var displayDetail: Bool = false
    let highestRisk: OutlookFeature?
    let isSignificant: Bool
    let selectedOutlook: OutlookType
    
    var errorMessage: String? {
        if case let .error(message) = outlookService.state {
            message
        } else {
            nil
        }
    }
    
    var body: some View {
        Button {
            displayDetail.toggle()
        } label: {
            HStack(alignment: .center, spacing: 4) {
                if let highestRisk {
                    /* Image(systemName: "circle")
                        .symbolRenderingMode(.monochrome)
                        .foregroundColor(.init(hex: highestRisk.outlookProperties.strokeColor)) */
                    
                    Image(systemName: "circle.inset.filled")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color(hex: highestRisk.outlookProperties.fillColor).opacity(0.50), Color(hex: highestRisk.outlookProperties.strokeColor))
                }
                
                if isSignificant {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .symbolRenderingMode(.multicolor)
                }
                
                Group {
                    if let highestRisk {
                        Text(highestRisk.outlookProperties.title)
                    } else if case .noData = outlookService.state {
                        Text("No data available")
                    } else if case .error = outlookService.state {
                        Text("\(Image(systemName: "xmark.circle.fill").symbolRenderingMode(.multicolor)) An error occurred")
                    } else {
                        Text("No risk zones at your location")
                    }
                }
                .font(.callout)
                
                if !highestRisk.isNil || !errorMessage.isNil {
                    Image(systemName: "chevron.right")
                        .imageScale(.small)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                }
                
                /* if isSignificant {
                    SigSevereBadgeView(theme: .light, font: .caption)
                } */
            }
        }
        .disabled(highestRisk.isNil && errorMessage.isNil)
        .buttonStyle(.plain)
        .sheet(isPresented: $displayDetail) {
            if let highestRisk {
                RiskDetailView(feature: highestRisk, isSignificant: isSignificant, atCurrentLocation: true, selectedOutlook: selectedOutlook)
            } else if let errorMessage {
                ErrorView(message: errorMessage)
            }
        }
    }
}

struct BottomToolbar: ToolbarContent {
    let highestRisk: OutlookFeature?
    let isSignificant: Bool
    @Binding var selectedOutlook: OutlookType
    @Binding var selectedMapStyle: OutlookMapView.Configuration
    @EnvironmentObject private var outlookService: OutlookService
    @State private var displayDetail: Bool = false
    @Binding var displaySettings: Bool
    
    var body: some ToolbarContent {
        CurrentLocationButton(highestRisk: highestRisk, isSignificant: isSignificant, selectedOutlook: selectedOutlook)
        .sheet(isPresented: $displaySettings) {
            SettingsView(selectedOutlook: $selectedOutlook, selectedMapStyle: $selectedMapStyle)
        }
        .toolbarItem(.bottomBar)
        
        Spacer()
            .toolbarItem(.bottomBar)
        
        Button {
            Task { await outlookService.load(selectedOutlook) }
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
