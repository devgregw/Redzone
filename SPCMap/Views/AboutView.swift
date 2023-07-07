//
//  AboutView.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/2/23.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    var sigSevereTitle: some View {
        HStack(alignment: .center) {
            SigSevereBadgeView(theme: .dark, font: .body)
            Text("Significant Severe")
                .font(.title3)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack(alignment: .center, spacing: 8) {
                        Spacer()
                        Image("NOAALogo")
                            .resizable()
                            .frame(width: 65, height: 65)
                            .accessibilityHidden(true)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Data provided by the")
                                .font(.callout.bold())
                            Text("National Oceanic and Atmospheric Administration's (NOAA) Storm Prediction Center (SPC)")
                                .font(.headline)
                            Text("U.C. Department of Commerce")
                                .font(.caption.bold().lowercaseSmallCaps())
                        }
                        .accessibilityElement(children: .combine)
                        Spacer()
                    }
                    .padding(.horizontal, 4)
                    .padding(.top)
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Categorical Risk Levels")
                            .font(.title.bold())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("General Thunderstorms (light green)")
                                .font(.title3)
                            Text("10% or higher probability of thunderstorms is forecast.")
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Marginal (1/5, dark green)")
                                .font(.title3)
                            Text("Severe storms of either limited organization and logevety, or very low coverage and marginal intensity.")
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Slight (2/5, yellow)")
                                .font(.title3)
                            Text("Organized severe thunderstorms are expected, but usually in low coverage with varying levels of intensity.")
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Enhanced (3/5, orange)")
                                .font(.title3)
                            Text("A greater concentration of organized severe thunderstorms with varying levels of intensity.")
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Moderage (4/5, red)")
                                .font(.title3)
                            Text("Potential for widespread severe weather with several tornadoes and/or numerous severe thunderstorms, some of which may be intense.")
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("High (5/5, magenta)")
                                .font(.title3)
                            Text("A severe weather outbreak is expected from either numerous intense and long-track tornadoes, or a long-lived derecho system with hurricane-force wind gusts producing widespread damage.")
                        }
                    }
                    .padding()
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Tornado Risk Levels")
                            .font(.title.bold())
                        
                        Text("Tornado risk is measured on a scale of 2%, 5%, 10%, 15%, 30%, 45%, and 60% with each percentage represening the forecasted probably of a tornado within 25 miles of a point.")
                        
                        VStack(alignment: .leading, spacing: 4) {
                            sigSevereTitle
                            Text("A significant severe region represents 10% or greater probability of EF2 - EF5 tornadoes within 25 miles of a point. This region is represented separately from the percentage regions and may overlap with them.")
                        }
                    }
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Wind Risk Levels")
                            .font(.title.bold())
                        
                        Text("Wind risk is measured on a scale of 5%, 15%, 30%, 45%, and 60% with each percentage represening the forecasted probably of damaging wind gusts of 50 knots (~60 miles per hour) or greater within 25 miles of a point.")
                        
                        VStack(alignment: .leading, spacing: 4) {
                            sigSevereTitle
                            Text("A significant severe region represents 10% or greater probability of 65-knot (~75 miles per hour) or greater wind gusts within 25 miles of a point. This region is represented separately from the percentage regions and may overlap with them.")
                        }
                    }
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Hail Risk Levels")
                            .font(.title.bold())
                        
                        Text("Hail risk is measured on a scale of 5%, 15%, 30%, 45%, and 60% with each percentage represening the forecasted probably of 1-inch diameter hail or larger within 25 miles of a point.")
                        
                        VStack(alignment: .leading, spacing: 4) {
                            sigSevereTitle
                            Text("A significant severe region represents 10% or greater probability of 2-inch diameter hail or larger within 25 miles of a point. This region is represented separately from the percentage regions and may overlap with them.")
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("About")
        }
        .presentationDragIndicator(.visible)
        .presentationDetents([.medium, .large])
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
