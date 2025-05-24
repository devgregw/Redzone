//
//  View.swift
//  RedzoneWidgets
//
//  Created by Greg Whatley on 8/19/24.
//

#if DEBUG
import SwiftUI
import WidgetKit

extension View {
    func widgetPreview<S: ShapeStyle>(as family: WidgetFamily, displayName: String? = nil, background: S) -> some View {
        self
            .previewDisplayName([String(describing: family), displayName].compactMap { $0 }.joined(separator: ": "))
            .containerBackground(background, for: .widget)
            .previewContext(WidgetPreviewContext(family: family))
    }
    
    func widgetPreview(as family: WidgetFamily = .systemSmall, displayName: String? = nil) -> some View {
        widgetPreview(as: family, displayName: displayName, background: .background)
    }
}
#endif
