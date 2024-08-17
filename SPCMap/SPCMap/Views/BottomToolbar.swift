//
//  BottomToolbar.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/8/23.
//

import SwiftUI

struct CurrentLocationButton: View {
    @Environment(OutlookService.self) private var outlookService
    @State private var displayDetail: Bool = false
    
    let highestRisk: OutlookFeature?
    let isSignificant: Bool
    
    private var errorMessage: String? {
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
                .lineLimit(1)
                .font(.callout)
                
                if !highestRisk.isNil || !errorMessage.isNil {
                    Image(systemName: "chevron.right")
                        .imageScale(.small)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .disabled(highestRisk.isNil && errorMessage.isNil)
        .buttonStyle(.plain)
        .sheet(isPresented: $displayDetail) {
            if let highestRisk {
                RiskDetailView(feature: highestRisk, isSignificant: isSignificant, atCurrentLocation: true)
            } else if let errorMessage {
                ErrorView(message: errorMessage)
            }
        }
    }
}

struct BottomToolbar: ToolbarContent {
    @Environment(OutlookService.self) private var outlookService
    @Environment(LocationService.self) private var locationService
    @Environment(Context.self) private var context
    
    let highestRisk: OutlookFeature?
    let isSignificant: Bool
    
    @State private var displayDetail: Bool = false
    
    var body: some ToolbarContent {
        @Bindable var context = context
        HStack {
            CurrentLocationButton(highestRisk: highestRisk, isSignificant: isSignificant)
                .sheet(isPresented: $context.displaySettingsSheet) {
                    SettingsView()
                }
            
            Spacer()
            
            Button {
                if !locationService.isUpdatingLocation {
                    locationService.requestPermission()
                } else if let location = locationService.lastKnownLocation?.coordinate {
                    context.moveCamera(to: location)
                }
            } label: {
                Image(systemName: "location\(locationService.isUpdatingLocation ? ".fill" : "")")
            }
            
            Button {
                await outlookService.refresh()
                if Settings.autoMoveCamera {
                    self.context.moveCamera(centering: outlookService.state)
                }
            } label: {
                Image(systemName: "arrow.clockwise")
            }
            
            Button {
                context.displaySettingsSheet.toggle()
            } label: {
                Image(systemName: "square.3.layers.3d")
            }
        }
        .toolbarItem(.bottomBar)
    }
}
