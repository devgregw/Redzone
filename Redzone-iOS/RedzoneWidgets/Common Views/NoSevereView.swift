//
//  NoSevereView.swift
//  RedzoneWidgets
//
//  Created by Greg Whatley on 4/7/24.
//

import SwiftUI
import WidgetKit

struct NoSevereView: View {
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall, .systemMedium, .systemLarge, .systemExtraLarge:
            VStack {
                Image(systemName: "sparkles")
                    .symbolRenderingMode(.multicolor)
                    .font(.largeTitle)
                Text("No severe weather forecast")
                    .multilineTextAlignment(.center)
                    .font(.footnote.weight(.medium))
                    .minimumScaleFactor(0.5)
            }
        case .accessoryInline:
            HStack {
                simpleView
            }
        case .accessoryRectangular:
            VStack {
                simpleView
            }
        default:
            #if DEBUG
            Image(systemName: "engine.combustion.badge.exclamationmark.fill")
                .font(.largeTitle)
                .symbolRenderingMode(.multicolor)
            #else
            EmptyView()
            #endif
        }
    }
    
    @ViewBuilder private var simpleView: some View {
        Image(systemName: "sparkles")
            .imageScale(.large)
        Text("No Severe Forecast")
            .multilineTextAlignment(.center)
    }
}

#if DEBUG
struct NoSevereView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(WidgetFamily.allCases, id: \.hashValue) {
            NoSevereView()
                .widgetPreview(as: $0)
        }
    }
}
#endif
