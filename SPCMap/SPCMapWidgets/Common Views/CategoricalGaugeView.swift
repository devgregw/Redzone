//
//  CategoricalGaugeView.swift
//  SPCMapWidgets
//
//  Created by Greg Whatley on 4/7/24.
//

import SwiftUI
import WidgetKit

struct CategoricalGaugeView: View {
    let value: Double
    let title: String
    let day: OutlookDay
    
    var body: some View {
        VStack(spacing: 1) {
            Gauge(value: value, in: 0...5) {
                Text("Categorical Risk")
                    .font(.body.bold())
                    .multilineTextAlignment(.center)
            } currentValueLabel: {
                Image("NOAALogo", bundle: .main)
                    .resizable()
                    .frame(width: 25, height: 25)
            } minimumValueLabel: {
                Text("GT")
            } maximumValueLabel: {
                Text("HI")
            }
            .gaugeStyle(.accessoryCircular)
            .tint(Gradient(colors: [.green.opacity(0.5), .green, .yellow, .orange, .red, .magenta]))
            Text(title)
                .multilineTextAlignment(.center)
                .font(.callout.weight(.medium))
                .minimumScaleFactor(0.5)
            DayLabel(day: day)
        }
    }
}

#if DEBUG
struct CategoricalGaugeView_Previews: PreviewProvider {
    static var previews: some View {
        CategoricalGaugeView(value: 3.0, title: "Enhanced Risk", day: .day1)
            .widgetPreview()
    }
}
#endif
