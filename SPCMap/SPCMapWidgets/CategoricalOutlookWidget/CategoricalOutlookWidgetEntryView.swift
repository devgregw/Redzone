//
//  CategoricalOutlookWidgetEntryView.swift
//  SPCMapWidgets
//
//  Created by Greg Whatley on 4/7/24.
//

import Foundation
import SwiftUI
import WidgetKit
import GeoJSON

struct CategoricalOutlookWidgetEntryView: WidgetFoundation.EntryView {
    typealias Provider = OutlookProvider
    typealias ErrorContent = WidgetErrorView
    
    let entry: Provider.Entry
    
    func mainContent(data: Provider.EntryData) -> some View {
        VStack(spacing: 4) {
            if let value = data.value,
               let title = data.title {
                CategoricalGaugeView(value: value, title: title, day: data.day)
            } else {
                VStack(spacing: 1) {
                    NoSevereView()
                    DayLabel(day: data.day)
                }
            }
            Spacer()
            DateLabel(entry: entry)
        }
    }
    
    @ViewBuilder var placeholderContent: some View {
        Circle()
            .fill(.secondary.quaternary)
            .frame(width: 50, height: 50)
        Text("Placeholder")
            .multilineTextAlignment(.center)
            .font(.callout.weight(.medium))
            .minimumScaleFactor(0.5)
            .redacted(reason: .placeholder)
    }
}

#Preview(as: .systemSmall) {
    CategoricalOutlookWidget()
} timeline: {
    OutlookProvider.Entry.preview
    OutlookProvider.Entry.placeholder
    OutlookProvider.Entry.success(.none)
    OutlookProvider.Entry.error(.noLocation)
    OutlookProvider.Entry.error(.unknown)
}
