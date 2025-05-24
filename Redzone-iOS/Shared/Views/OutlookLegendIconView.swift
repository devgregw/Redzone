//
//  OutlookLegendIconView.swift
//  Redzone
//
//  Created by Greg Whatley on 2/11/24.
//

import SwiftUI

struct OutlookLegendIconView: View {
    let fillColor: Color
    let strokeColor: Color
    
    init(fillColor: Color, strokeColor: Color) {
        self.fillColor = fillColor
        self.strokeColor = strokeColor
    }
    
    init(properties: OutlookProperties) {
        self.init(fillColor: properties.fillColor.opacity(0.50), strokeColor: properties.strokeColor)
    }
    
    var body: some View {
        Image(systemName: "circle.inset.filled")
            .symbolRenderingMode(.palette)
            .foregroundStyle(fillColor, strokeColor)
    }
}

#Preview {
    VStack {
        OutlookLegendIconView(fillColor: .blue, strokeColor: .yellow)
        OutlookLegendIconView(
            properties: .init(
                id: "",
                title: "",
                fillColor: "#FFFF00",
                strokeColor: "#FF0000",
                expire: "",
                valid: "",
                issue: ""
            )
        )
    }
}
