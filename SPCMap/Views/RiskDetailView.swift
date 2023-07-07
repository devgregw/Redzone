//
//  RiskDetailView.swift
//  SPC
//
//  Created by Greg Whatley on 4/8/23.
//

import SafariServices
import SwiftUI

struct RiskDetailView: View {
    let properties: OutlookProperties
    let isSignificant: Bool
    let atCurrentLocation: Bool
    let selectedOutlook: OutlookType
    
    init(properties: OutlookProperties, isSignificant: Bool, atCurrentLocation: Bool, selectedOutlook: OutlookType) {
        self.properties = properties
        self.isSignificant = isSignificant
        self.atCurrentLocation = atCurrentLocation
        self.selectedOutlook = selectedOutlook
    }
    
    init(feature: OutlookFeature, isSignificant: Bool, atCurrentLocation: Bool, selectedOutlook: OutlookType) {
        self.init(properties: feature.outlookProperties, isSignificant: isSignificant, atCurrentLocation: atCurrentLocation, selectedOutlook: selectedOutlook)
    }
    
    init(polygon: OutlookMultiPolygon, isSignificant: Bool, atCurrentLocation: Bool, selectedOutlook: OutlookType) {
        self.init(properties: polygon.properties, isSignificant: isSignificant, atCurrentLocation: atCurrentLocation, selectedOutlook: selectedOutlook)
    }
    
    @State private var presentCommentary: Bool = false
    
    private var commentaryURL: URL {
        URL(string: "https://www.spc.noaa.gov/products/outlook/day\(selectedOutlook.day)otlk.html")!
    }
    
    private var outlookTitleIcon: Image {
        Image(systemName: atCurrentLocation ? "location.circle.fill" : "location.slash").symbolRenderingMode(atCurrentLocation ? .multicolor : .hierarchical)
    }
    
    private var significantIcon: Image {
        Image(systemName: atCurrentLocation ? "exclamationmark.triangle.fill" : "location.slash").symbolRenderingMode(atCurrentLocation ? .multicolor : .hierarchical)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("\(outlookTitleIcon) \(properties.title)")
                        .font(.title3.bold())
                        .padding(.bottom)
                    
                    switch selectedOutlook.convectiveSubtype {
                    case .categorical:
                        switch properties.severity {
                        case .generalThunder: Text("10% or higher probability of thunderstorms is forecast.")
                        case .marginal: Text("Severe storms of either limited organization and logevety, or very low coverage and marginal intensity.")
                        case .slight: Text("Organized severe thunderstorms are expected, but usually in low coverage with varying levels of intensity.")
                        case .enhanced: Text("A greater concentration of organized severe thunderstorms with varying levels of intensity.")
                        case .moderate: Text("Potential for widespread severe weather with several tornadoes and/or numerous severe thunderstorms, some of which may be intense.")
                        case .high: Text("A severe weather outbreak is expected from either numerous intense and long-track tornadoes, or a long-lived derecho system with hurricane-force wind gusts producing widespread damage.")
                        default: Text("Unknown: \(selectedOutlook.path) \(properties.id)")
                        }
                    case .wind:
                        Text("Forecasted probability of damaging wind gusts of 50 knots (~60 miles per hour) or greater within 25 miles of a point.")
                    case .hail:
                        Text("Forecasted probability of 1-inch diameter or larger within 25 miles of a point.")
                    case .tornado:
                        Text("Forecasted probability of a tornado within 25 miles of a point.")
                    case nil: EmptyView()
                    }
                    
                    if isSignificant {
                        Divider()
                            .padding(.vertical)
                        Text("\(significantIcon) Significant Severe")
                            .font(.title3.bold())
                            .padding(.bottom)
                        switch selectedOutlook.convectiveSubtype {
                        case .hail:
                            Text("10% or greater probability of 2-inch diameter or larger within 25 miles of a point.")
                        case .wind:
                            Text("10% or greater probability of damaging wind gusts of 65 knots (~75 miles per hour) or greater within 25 miles of a point.")
                        case .tornado:
                            Text("10% or greater probability of EF2 - EF5 tornadoes within 25 miles of a point.")
                        default: EmptyView()
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
            .navigationTitle(atCurrentLocation ? "Forecasted at Your Location" : "Tapped Outlook")
            .navigationBarTitleDisplayMode(.inline)
        }
        .scrollContentBackground(.hidden)
        .presentationBackground(.ultraThinMaterial)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
