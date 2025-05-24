//
//  TimelineReloadPolicy.swift
//  RedzoneWidgets
//
//  Created by Greg Whatley on 8/20/24.
//

import WidgetKit

extension TimelineReloadPolicy {
    @inlinable static func after(hours: Int) -> TimelineReloadPolicy {
        .after(.now.addingTimeInterval(3600.0 * Double(hours)))
    }
}
