//
//  OutlookPicker.swift
//  SPC
//
//  Created by Greg Whatley on 4/8/23.
//

import SwiftUI

struct OutlookPicker: View {
    private let standardTypes: [String] = [
        "Categorical", "Wind", "Hail", "Tornado"
    ]
    
    private let day3Types: [String] = [
        "Categorical", "Probabilistic", "Sig. Prob."
    ]
    
    private var outlookTypeChoices: [String] {
        1..<3 ~= timeFrame ? standardTypes : day3Types
    }
    
    @Binding var selectedOutlookType: String
    var timeFrame: Int
    
    var body: some View {
        /* HStack {
            Picker("Outlook type", selection: $selectedOutlookType) {
                ForEach(outlookTypeChoices, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
        } */
        
        Picker(selection: $selectedOutlookType) {
            ForEach(outlookTypeChoices, id: \.self, content: Text.init(_:))
        } label: {
            Label("Layer", systemImage: "square.3.layers.3d.top.filled")
                .symbolRenderingMode(.hierarchical)
        }
    }
}
