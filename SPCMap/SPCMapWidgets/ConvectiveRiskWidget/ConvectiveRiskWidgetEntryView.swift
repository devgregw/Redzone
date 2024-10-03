//
//  ConvectiveRiskWidgetEntryView.swift
//  SPCMap
//
//  Created by Greg Whatley on 10/2/24.
//

import SwiftUI
import WidgetKit

struct ConvectiveRiskWidgetEntryView: WidgetFoundation.EntryView {
    typealias Provider = OutlookProvider
    typealias ErrorContent = WidgetErrorView
    
    @Environment(\.widgetFamily) var widgetFamily
    let entry: Provider.Entry
    
    func mainContent(data: Provider.EntryData) -> some View {
        switch widgetFamily {
        case .accessoryRectangular, .accessoryInline:
            RiskBreakdownWidgetEntryView(entry: entry)
                .containerBackground(.regularMaterial, for: .widget)
        case .systemSmall:
            CategoricalOutlookWidgetEntryView(entry: entry)
                .containerBackground(.background, for: .widget)
        case .systemMedium:
            CombinedRiskWidgetEntryView(entry: entry)
                .containerBackground(.background, for: .widget)
        case .accessoryCircular:
            NoSevereView()
        default:
            UnsupportedWidgetFamilyView()
                .containerBackground(.background, for: .widget)
        }
    }
}

#if DEBUG
struct ConvectiveRiskWidget_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(WidgetFamily.allCases) { family in
            ConvectiveRiskWidgetEntryView(entry: .preview)
                .widgetPreview(as: family)
        }
    }
}
#endif
