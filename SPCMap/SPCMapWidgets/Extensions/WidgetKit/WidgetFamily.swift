//
//  WidgetFamily.swift
//  SPCMapWidgets
//
//  Created by Greg Whatley on 8/19/24.
//

#if DEBUG
import WidgetKit

extension WidgetFamily: CaseIterable {
    public static let allCases: [WidgetFamily] = [
        .systemSmall,
        .systemMedium,
        .systemLarge,
        .systemExtraLarge,
        .accessoryInline,
        .accessoryCircular,
        .accessoryRectangular
    ]
}

extension WidgetFamily: Identifiable {
    public var id: Int { hashValue }
}
#endif
