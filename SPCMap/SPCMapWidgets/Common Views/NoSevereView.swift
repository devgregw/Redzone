//
//  NoSevereView.swift
//  SPCMapWidgets
//
//  Created by Greg Whatley on 4/7/24.
//

import SwiftUI
import WidgetKit

struct NoSevereView: View {
    let day: OutlookDay
    
    var body: some View {
        VStack(spacing: 1) {
            Image(systemName: "sparkles")
                .symbolRenderingMode(.multicolor)
                .font(.largeTitle)
            Text("No severe weather forecast")
                .multilineTextAlignment(.center)
                .font(.footnote.weight(.medium))
                .minimumScaleFactor(0.5)
            DayLabel(day: day)
        }
    }
}

#Preview(as: .systemSmall) {
    DayOneOutlookWidget()
} timeline: {
    DayOneOutlookWidget.Provider.Entry.outlook(.now, nil)
}
