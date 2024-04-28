//
//  WidgetErrorView.swift
//  SPCMapWidgets
//
//  Created by Greg Whatley on 4/7/24.
//

import SwiftUI
import WidgetKit

struct WidgetErrorView: View {
    let error: EntryError
    
    var body: some View {
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
                Image("NOAALogo", bundle: .main)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .background(.background)
                            .clipShape(Circle())
                            .symbolRenderingMode(.multicolor)
                    }
                Text("Unknown error")
                    .multilineTextAlignment(.center)
                    .font(.footnote.weight(.medium))
                    .minimumScaleFactor(0.5)
            }
        }
    }
}

#Preview(as: .systemSmall) {
    DayOneOutlookWidget()
} timeline: {
    DayOneOutlookWidget.Provider.Entry.error(.noLocation)
    DayOneOutlookWidget.Provider.Entry.error(.unknown)
}
