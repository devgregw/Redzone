//
//  RiskDetailView.swift
//  Redzone
//
//  Created by Greg Whatley on 4/8/23.
//

import SafariServices
import SwiftUI
import GeoJSON

struct RiskDetailView: View {
    @Environment(Context.self) private var context
    
    let properties: OutlookProperties
    let isSignificant: Bool
    let atCurrentLocation: Bool
    
    init(properties: OutlookProperties, isSignificant: Bool, atCurrentLocation: Bool) {
        self.properties = properties
        self.isSignificant = isSignificant
        self.atCurrentLocation = atCurrentLocation
    }
    
    init(feature: GeoJSONFeature, isSignificant: Bool, atCurrentLocation: Bool) {
        self.init(properties: feature.outlookProperties, isSignificant: isSignificant, atCurrentLocation: atCurrentLocation)
    }
        
    private var commentaryURL: URL? {
        URL(string: "https://www.spc.noaa.gov/products/outlook/day\(context.outlookType.day)otlk.html")
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
                    HStack {
                        outlookTitleIcon
                        OutlookLegendIconView(properties: properties)
                        Text(properties.title)
                    }
                    .font(.title3.bold())
                    .padding(.bottom)
                    
                    switch context.outlookType.convectiveSubtype {
                    case .categorical:
                        switch properties.severity {
                        case .generalThunder: Text("10% or higher probability of thunderstorms is forecast.")
                        case .marginal: Text("Severe storms of either limited organization and logevety, or very low coverage and marginal intensity.")
                        case .slight: Text("Organized severe thunderstorms are expected, but usually in low coverage with varying levels of intensity.")
                        case .enhanced: Text("A greater concentration of organized severe thunderstorms with varying levels of intensity.")
                        case .moderate: Text("Potential for widespread severe weather with several tornadoes and/or numerous severe thunderstorms, some of which may be intense.")
                        case .high: Text("A severe weather outbreak is expected from either numerous intense and long-track tornadoes, or a long-lived derecho system with hurricane-force wind gusts producing widespread damage.")
                        default: Text("Unknown: \(context.outlookType.path) \(properties.id)")
                        }
                    case .wind:
                        Text("Forecasted probability of damaging wind gusts of 50 knots (~60 miles per hour) or greater within 25 miles of a point.")
                    case .hail:
                        Text("Forecasted probability of 1-inch diameter hail or larger within 25 miles of a point.")
                    case .tornado:
                        Text("Forecasted probability of a tornado within 25 miles of a point.")
                    case nil: EmptyView()
                    }
                    
                    if isSignificant {
                        Divider()
                            .padding(.vertical)
                        HStack {
                            significantIcon
                            SigSevLegendIconView()
                            Text("Significant Severe")
                        }
                        .font(.title3.bold())
                        .padding(.bottom)
                        
                        switch context.outlookType.convectiveSubtype {
                        case .hail:
                            Text("10% or greater probability of 2-inch diameter hail or larger within 25 miles of a point.")
                        case .wind:
                            Text("10% or greater probability of damaging wind gusts of 65 knots (~75 miles per hour) or greater within 25 miles of a point.")
                        case .tornado:
                            Text("10% or greater probability of EF2 - EF5 tornadoes within 25 miles of a point.")
                        default: EmptyView()
                        }
                    }
                    
                    Divider()
                        .padding(.vertical)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        NavigationLink {
                            switch context.outlookType {
                            case .convective1, .convective2, .convective3(probabilistic: false):
                                switch context.outlookType.convectiveSubtype {
                                case .categorical: AboutCategoricalRiskView()
                                case .wind: PercentageRiskDetailView.wind
                                case .hail: PercentageRiskDetailView.hail
                                case .tornado: PercentageRiskDetailView.tornado
                                default: EmptyView()
                                }
                            case .convective3(probabilistic: true):
                                PercentageRiskDetailView.probabilistic3
                            default:
                                PercentageRiskDetailView.probabilistic48
                            }
                        } label: {
                            HStack {
                                Label("About This Risk", systemImage: "questionmark.circle")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .imageScale(.small)
                            }
                        }
                        
                        LabelledLink("Safety for All Hazards", destination: "https://www.weather.gov/safety", systemImage: "staroflife")
                        
                        if properties.title.contains("Tornado") {
                            LabelledLink("About The Enhanced Fujita (EF) Scale", destination: "https://www.spc.noaa.gov/efscale", systemImage: "tornado")
                        }
                        
                        if let commentaryURL {
                            LabelledLink("Forecast Discussion", destination: commentaryURL, systemImage: "exclamationmark.bubble")
                        }
                    }
                    
                    if let issued = properties.issueDate,
                       let expires = properties.expireDate,
                       let valid = properties.validDate {
                        Divider()
                            .padding(.vertical)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Issued on")
                                Spacer()
                                Text(issued, format: .dateTime.year().month().day().hour().minute().timeZone())
                                    .monospaced()
                            }
                            HStack {
                                if valid...expires ~= .now {
                                    Text("Valid until")
                                    Spacer()
                                    Image(systemName: "clock.badge.checkmark.fill")
                                        .symbolRenderingMode(.multicolor)
                                    Text(expires, format: .dateTime.year().month().day().hour().minute().timeZone())
                                        .monospaced()
                                } else if .now > expires {
                                    Text("Expired on")
                                    Spacer()
                                    Image(systemName: "clock.badge.xmark.fill")
                                        .symbolRenderingMode(.multicolor)
                                    Text(expires, format: .dateTime.year().month().day().hour().minute().timeZone())
                                        .monospaced()
                                } else {
                                    Text("Valid from")
                                    Spacer()
                                    Image(systemName: "clock.fill")
                                        .foregroundStyle(.orange)
                                    Text(expires, format: .dateTime.year().month().day().hour().minute().timeZone())
                                        .monospaced()
                                }
                            }
                        }
                        .foregroundStyle(.foreground.secondary)
                        .font(.footnote)
                    }
                }
                .padding([.horizontal, .bottom])
            }
            .toolbar {
                DismissButton()
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
