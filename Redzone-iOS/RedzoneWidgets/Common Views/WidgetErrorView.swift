//
//  WidgetErrorView.swift
//  RedzoneWidgets
//
//  Created by Greg Whatley on 4/7/24.
//

import SwiftUI
import WidgetKit

struct WidgetErrorView: View {
    @Environment(\.widgetFamily) var widgetFamily
    
    let error: WidgetFoundation.EntryError
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall, .systemMedium, .systemLarge, .systemExtraLarge:
            standardView
        case .accessoryRectangular:
            VStack {
                simpleView
            }
        case .accessoryInline:
            HStack {
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
}

extension WidgetErrorView {
    private var standardView: some View {
        VStack(spacing: 1) {
            switch error {
            case .noLocation:
                Image(systemName: "location.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .font(.largeTitle)
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .background(.background)
                            .clipShape(Circle())
                            .symbolRenderingMode(.multicolor)
                    }
                Text("Location services unavailable")
                    .multilineTextAlignment(.center)
                    .font(.footnote.weight(.medium))
                    .minimumScaleFactor(0.5)
            case .unknown:
                Image(systemName: "exclamationmark.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .font(.largeTitle)
                Text("Unknown error")
                    .multilineTextAlignment(.center)
                    .font(.footnote.weight(.medium))
                    .minimumScaleFactor(0.5)
            }
        }
    }
    
    private var simpleView: some View {
        Group {
            switch error {
            case .noLocation:
                Image(systemName: "location.slash.circle.fill")
                Text("No Location")
            case .unknown:
                Image(systemName: "exclamationmark.circle.fill")
                Text("Unknown Error")
            }
        }
        .multilineTextAlignment(.center)
    }
}

#if DEBUG
struct WidgetErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(WidgetFamily.allCases, id: \.hashValue) { family in
            ForEach([WidgetFoundation.EntryError.noLocation, .unknown], id: \.hashValue) { error in
                WidgetErrorView(error: error)
                    .widgetPreview(as: family, displayName: String(describing: error))
            }
        }
    }
}
#endif
