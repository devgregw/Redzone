//
//  OutlookLegendIconView.swift
//  RedzoneUI
//
//  Created by Greg Whatley on 9/21/25.
//

import RedzoneCore
import SwiftUI

public struct OutlookLegendIconView: View {
    let fillColor: Color
    let strokeColor: Color
    
    public init(fillColor: Color, strokeColor: Color) {
        self.fillColor = fillColor
        self.strokeColor = strokeColor
    }
    
    public init(properties: Outlook.Properties) {
        self.init(fillColor: Color(hex: properties.fillColor).opacity(0.50), strokeColor: Color(hex: properties.strokeColor))
    }
    
    public var body: some View {
        Image(systemName: "circle.inset.filled")
            .symbolRenderingMode(.palette)
            .foregroundStyle(fillColor, strokeColor)
            .padding(2)
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
