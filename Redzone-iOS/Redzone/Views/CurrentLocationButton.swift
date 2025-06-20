//
//  CurrentLocationButton.swift
//  Redzone
//
//  Created by Greg Whatley on 4/8/23.
//

import SwiftUI
import GeoJSON

struct CurrentLocationButton: View {
    @Environment(OutlookService.self) private var outlookService
    @State private var displayDetail: Bool = false
    
    let highestRisk: GeoJSONFeature?
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
                        .foregroundStyle(highestRisk.outlookProperties.fillColor.opacity(0.50), highestRisk.outlookProperties.strokeColor)
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
                        .font(.callout.bold())
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .clippedBackground()
        .padding([.horizontal, .bottom], 8)
    }
}
