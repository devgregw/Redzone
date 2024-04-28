//
//  SPCMapApp.swift
//  SPCMap
//
//  Created by Greg Whatley on 3/15/23.
//

import SwiftUI
import WidgetKit

@main
struct SPCApp: App {
    @State private var outlookService = OutlookService()
    @State private var context = Context()
    @State private var locationService = LocationService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(outlookService)
                .environment(context)
                .environment(locationService)
                .onReceive(outlookService.debouncePublisher) {
                    Logger.log(.widgets, "Reloading all timelines")
                    WidgetCenter.shared.getCurrentConfigurations {
                        if case let .success(widgets) = $0 {
                            widgets.forEach { widget in
                                Logger.log(.widgets, "- \(widget.kind) [\(widget.family.description)]: config = \(widget.widgetConfigurationIntent(of: OutlookDayConfigurationIntent.self)?.day.rawValue ?? -1)")
                            }
                        }
                    }
                    WidgetCenter.shared.reloadAllTimelines()
                }
                .onReceive(locationService.debouncePublisher) {
                    Settings.lastKnownLocation = $0.coordinate
                }
        }
    }
}
