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
    @CodedAppStorage(AppStorageKeys.outlookType) private var outlookType: OutlookType = Context.defaultOutlookType
    
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
        
    private var commentaryURL: String {
        "https://www.spc.noaa.gov/products/outlook/day\(outlookType.day)otlk.html"
    }
    
    private var outlookTitleIcon: Image {
        Image(systemName: atCurrentLocation ? "location.circle.fill" : "location.slash").symbolRenderingMode(atCurrentLocation ? .multicolor : .hierarchical)
    }
    
    private var significantIcon: Image {
        Image(systemName: atCurrentLocation ? "exclamationmark.triangle.fill" : "location.slash").symbolRenderingMode(atCurrentLocation ? .multicolor : .hierarchical)
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading) {
                        HStack {
                            outlookTitleIcon
                            OutlookLegendIconView(properties: properties)
                            Text(properties.title)
                        }
                        .font(.title3.bold())
                        
                        switch outlookType.convectiveSubtype {
                        case .categorical:
                            switch properties.severity {
                            case .generalThunder: Text("10% or higher probability of thunderstorms is forecast.")
                            case .marginal: Text("Severe storms of either limited organization and logevety, or very low coverage and marginal intensity.")
                            case .slight: Text("Organized severe thunderstorms are expected, but usually in low coverage with varying levels of intensity.")
                            case .enhanced: Text("A greater concentration of organized severe thunderstorms with varying levels of intensity.")
                            case .moderate: Text("Potential for widespread severe weather with several tornadoes and/or numerous severe thunderstorms, some of which may be intense.")
                            case .high: Text("A severe weather outbreak is expected from either numerous intense and long-track tornadoes, or a long-lived derecho system with hurricane-force wind gusts producing widespread damage.")
                            default: EmptyView()
                            }
                        case .wind:
                            Text("Forecasted probability of damaging wind gusts of 50 knots (~60 miles per hour) or greater within 25 miles of a point.")
                        case .hail:
                            Text("Forecasted probability of 1-inch diameter hail or larger within 25 miles of a point.")
                        case .tornado:
                            Text("Forecasted probability of a tornado within 25 miles of a point.")
                        default: EmptyView()
                        }
                    }
                    
                    if isSignificant {
                        VStack(alignment: .leading) {
                            HStack {
                                significantIcon
                                SigSevLegendIconView()
                                Text("Significant Severe")
                            }
                            .font(.title3.bold())
                            
                            switch outlookType.convectiveSubtype {
                            case .hail:
                                Text("10% or greater probability of 2-inch diameter hail or larger within 25 miles of a point.")
                            case .wind:
                                Text("10% or greater probability of damaging wind gusts of 65 knots (~75 miles per hour) or greater within 25 miles of a point.")
                            case .tornado:
                                Text("10% or greater probability of EF2 - EF5 tornadoes within 25 miles of a point.")
                            default: EmptyView()
                            }
                        }
                    }
                    
                    NavigationLink {
                        switch outlookType {
                        case .convective1, .convective2, .convective3(probabilistic: false):
                            switch outlookType.convectiveSubtype {
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
                        Label("About This Risk", systemImage: "questionmark.circle")
                    }
                    
                    LabelledLink("Forecast Discussion", destination: commentaryURL, image: .noaaLogo)
                }
                
                SafetyLinksSection(tornado: properties.title.contains("Tornado"))
                
                if let issued = properties.issueDate,
                   let expires = properties.expireDate,
                   let valid = properties.validDate {
                    Section {
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
                                Text(expires, format: .dateTime.year().month().day().hour().minute().timeZone())
                                    .monospaced()
                            } else if .now > expires {
                                Text("Expired on")
                                Spacer()
                                Text(expires, format: .dateTime.year().month().day().hour().minute().timeZone())
                                    .monospaced()
                            } else {
                                Text("Valid from")
                                Spacer()
                                Text(expires, format: .dateTime.year().month().day().hour().minute().timeZone())
                                    .monospaced()
                            }
                        }
                    }
                    .foregroundStyle(.primary.opacity(0.8))
                    .font(.footnote)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowSpacing(.zero)
                    .listRowInsets(EdgeInsets())
                }
            }
            .toolbar {
                DismissButton()
            }
            .navigationTitle(atCurrentLocation ? "Your Forecast" : "Selected Outlook")
            .navigationBarTitleDisplayMode(.inline)
        }
        .scrollContentBackground(.hidden)
        .presentationBackground(.ultraThinMaterial)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
