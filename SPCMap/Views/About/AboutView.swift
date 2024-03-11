//
//  AboutView.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/2/23.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        List {
            Section("Data Source") {
                Button {
                    openURL(URL(string: "https://spc.noaa.gov")!)
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
