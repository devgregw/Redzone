//
//  WidgetFamily.swift
//  RedzoneWidgets
//
//  Created by Greg Whatley on 8/19/24.
//

#if DEBUG
import WidgetKit

extension WidgetFamily: @retroactive CaseIterable {
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

extension WidgetFamily: @retroactive Identifiable {
    public var id: Int { hashValue }
}
#endif
