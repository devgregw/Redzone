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
            @Bindable var bindableContext = context
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
                .openURL(url: $bindableContext.presentedURL)
                .onOpenURL {
                    Logger.log(.widgets, "Handling URL: \($0.absoluteString)")
                    guard $0.scheme == "whatley",
                          let components = URLComponents(url: $0, resolvingAgainstBaseURL: true),
                          components.host == "spcapp",
                          let day = Int(components.queryItems?.first(where: { $0.name == "setOutlook" })?.value ?? ""),
                          let outlookDay = OutlookDay(rawValue: day) else {
                        Logger.log(.widgets, "Not sure how to handle this URL")
                        return
                    }
                    switch outlookDay {
                    case .day1: context.outlookType = .convective1(.categorical)
                    case .day2: context.outlookType = .convective2(.categorical)
                    }
                }
        }
    }
}
