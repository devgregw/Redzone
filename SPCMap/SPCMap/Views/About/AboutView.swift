//
//  AboutView.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/2/23.
//

import SwiftUI

struct AboutView: View {
    @Environment(Context.self) private var context
    
    var body: some View {
        List {
            Section("Data Source") {
                Button {
                    context.presentedURL = URL(string: "https://spc.noaa.gov")!
                } label: {
                    HStack(alignment: .center) {
                        Image("NOAALogo")
                            .resizable()
                            .frame(width: 65, height: 65)
                            .accessibilityHidden(true)
                        
                        VStack(alignment: .leading) {
                            Text("National Weather Service")
                                .font(.headline)
                            Text("Storm Prediction Center")
                                .font(.headline)
                            Text("U.S. Department of Commerce")
                                .font(.caption.bold().lowercaseSmallCaps())
                        }
                        .foregroundStyle(Color(.label))
                        .accessibilityElement(children: .combine)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.forward.square")
                    }
                }
            }
            
            RiskLevelLinksView()
            
            Section("Safety") {
                Button {
                    context.presentedURL = URL(string: "https://www.weather.gov/safety/")!
                } label: {
                    HStack {
                        Label("National Weather Service Safety Tips", systemImage: "staroflife")
                        Spacer()
                        Image(systemName: "arrow.up.forward.square")
                    }
                }
            }
        }
        .scrollContentBackground(.visible)
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
}
