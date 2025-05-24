//
//  Timeline.swift
//  RedzoneWidgets
//
//  Created by Greg Whatley on 8/20/24.
//

import WidgetKit

extension Timeline {
    @inlinable init(entry: EntryType, policy: TimelineReloadPolicy) {
        self.init(entries: [entry], policy: policy)
    }
}
