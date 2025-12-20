//
//  CategoricalGaugeView.swift
//  RedzoneUI
//
//  Created by Greg Whatley on 9/21/25.
//

import RedzoneCore
import SwiftUI

public struct CategoricalGaugeView: View {
    public enum Mode: Hashable, Sendable {
        case legend
        case numeric
    }

    private let properties: Outlook.Properties
    private let mode: Mode

    public init(properties: Outlook.Properties, mode: Mode = .numeric) {
        self.properties = properties
        self.mode = mode
    }

    public var body: some View {
        let value = min(max(properties.severity.comparableValue, 0), 5)
        Gauge(value: value, in: 0...5) {
            Text("Categorical Risk")
                .font(.body.bold())
                .multilineTextAlignment(.center)
        } currentValueLabel: {
            if mode == .numeric {
                Text("\(Int(value))/5")
                    .font(.footnote.bold())
            } else {
                OutlookLegendIconView(properties: properties)
                    .imageScale(.small)
            }
        } minimumValueLabel: {
            Text("GT")
        } maximumValueLabel: {
            Text("HI")
        }
        .gaugeStyle(.accessoryCircular)
        .tint(Gradient(colors: [.green.opacity(0.5), .green, .yellow, .orange, .red, .magenta]))
    }
}
