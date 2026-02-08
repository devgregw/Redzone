//
//  RiskView.swift
//  Redzone
//
//  Created by Greg Whatley on 2/7/26.
//

import RedzoneUI
import SwiftUI

struct RiskView: View, Hashable {
    let title: LocalizedStringResource
    let description: LocalizedStringResource
    let color: Color
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title.key)
        hasher.combine(description.key)
        hasher.combine(color)
    }
    
    static func == (lhs: RiskView, rhs: RiskView) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label {
                Text(title)
                    .font(.headline)
            } icon: {
                OutlookLegendIconView(fillColor: color.opacity(0.5), strokeColor: color)
                    .shadow(color: color.opacity(0.5), radius: 10)
            }
            Text(description)
        }
    }
}
