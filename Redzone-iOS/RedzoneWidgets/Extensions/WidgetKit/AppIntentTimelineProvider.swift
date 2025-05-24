//
//  AppIntentTimelineProvider.swift
//  RedzoneWidgets
//
//  Created by Greg Whatley on 8/20/24.
//

import WidgetKit

extension AppIntentTimelineProvider where Self: WidgetFoundation.Provider, Self.Entry == WidgetFoundation.Entry<Self.EntryData> {
    func placeholder(in context: Context) -> Entry {
        .placeholder
    }
    
    func snapshot(for configuration: Intent, in context: Context) async -> Entry {
        .preview
    }
}
