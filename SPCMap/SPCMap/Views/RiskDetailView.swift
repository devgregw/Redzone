//
//  RiskDetailView.swift
//  SPC
//
//  Created by Greg Whatley on 4/8/23.
//

import SafariServices
import SwiftUI
import SPCCommon

struct RiskDetailView: View {
    let outlook: Outlook
    let isSignificant: Bool
    let atCurrentLocation: Bool
    let selectedType: String
    let timeFrame: Int
    
    @State private var presentCommentary: Bool = false
    
    private var commentaryURL: URL {
        URL(string: "https://www.spc.noaa.gov/products/outlook/day\(timeFrame)otlk.html")!
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    if atCurrentLocation {
                        Text("\(Image(systemName: "location.circle.fill").symbolRenderingMode(.multicolor)) \(outlook.name)")
                            .font(.title3.bold())
                            .padding(.bottom)
                    }
                    
                    switch selectedType {
                    case "Hail":
                        Text("Forecasted probability of 1-inch diameter or larger within 25 miles of a point.")
                    case "Wind":
                        Text("Forecasted probability of damaging wind gusts of 50 knots (~60 miles per hour) or greater within 25 miles of a point.")
                    case "Tornado":
                        Text("Forecasted probability of a tornado within 25 miles of a point.")
                    default:
                        switch outlook.type {
                        case .generalThunder: Text("10% or higher probability of thunderstorms is forecast.")
                        case .marginal: Text("Severe storms of either limited organization and logevety, or very low coverage and marginal intensity.")
                        case .slight: Text("Organized severe thunderstorms are expected, but usually in low coverage with varying levels of intensity.")
                        case .enhanced: Text("A greater concentration of organized severe thunderstorms with varying levels of intensity.")
                        case .moderate: Text("Potential for widespread severe weather with several tornadoes and/or numerous severe thunderstorms, some of which may be intense.")
                        case .high: Text("A severe weather outbreak is expected from either numerous intense and long-track tornadoes, or a long-lived derecho system with hurricane-force wind gusts producing widespread damage.")
                        default: Text("Unknown: \(selectedType) \(outlook.id)")
                        }
                    }
                    
                    if isSignificant {
                        Divider()
                            .padding(.vertical)
                        Text("\(Image(systemName: "exclamationmark.triangle.fill").symbolRenderingMode(.multicolor)) Significant Severe")
                            .font(.title3.bold())
                            .padding(.bottom)
                        switch selectedType {
                        case "Hail":
                            Text("10% or greater probability of 2-inch diameter or larger within 25 miles of a point.")
                        case "Wind":
                            Text("10% or greater probability of damaging wind gusts of 65 knots (~75 miles per hour) or greater within 25 miles of a point.")
                        case "Tornado":
                            Text("10% or greater probability of EF2 - EF5 tornadoes within 25 miles of a point.")
                        default:
                            Text(selectedType)
                        }
                    }
                    
                    Divider()
                        .padding(.vertical)
                    
                    Button {
                        presentCommentary.toggle()
                    } label: {
                        Label("SPC Forecast Discussion", systemImage: "exclamationmark.bubble")
                    }
                    .fullScreenCover(isPresented: $presentCommentary) {
                        SafariView(url: commentaryURL)
                            .ignoresSafeArea(.all)
                    }
                }
                .padding([.horizontal, .bottom])
            }
            .navigationTitle("Forecasted at your location")
            .navigationBarTitleDisplayMode(.inline)
        }
        .scrollContentBackground(.hidden)
        .presentationBackground(.ultraThinMaterial)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
