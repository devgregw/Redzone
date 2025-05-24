//
//  DateLabel.swift
//  RedzoneWidgets
//
//  Created by Greg Whatley on 8/18/24.
//

import SwiftUI
import WidgetKit

struct DateLabel<D: WidgetFoundation.EntryData>: View {
    let entry: WidgetFoundation.Entry<D>
    
    var body: some View {
        Label(entry.date.formatted(date: .numeric, time: .shortened), systemImage: "clock")
            .minimumScaleFactor(0.5)
            .lineLimit(1)
            .foregroundStyle(.secondary)
            .font(.caption2)
    }
}

#if DEBUG
struct DateLabel_Previews: PreviewProvider {
    struct PreviewData: WidgetFoundation.EntryData {
        static let preview: Self = .init()
        static let none: Self = .preview
        
        let date: Date = .now
    }
    
    static var previews: some View {
        DateLabel<PreviewData>(entry: .success(.preview))
            .widgetPreview()
    }
}
#endif
