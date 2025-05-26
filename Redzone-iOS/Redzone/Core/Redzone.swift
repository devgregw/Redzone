//
//  Redzone.swift
//  Redzone
//
//  Created by Greg Whatley on 3/15/23.
//

import SwiftUI
import WidgetKit

@main
struct Redzone: App {
    @CodedAppStorage(AppStorageKeys.outlookType) private var outlookType: OutlookType = Context.defaultOutlookType
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
                .onOpenURL {
                    Logger.log(.widgets, "Handling URL: \($0.absoluteString)")
                    guard $0.scheme == "whatley",
                          let components = URLComponents(url: $0, resolvingAgainstBaseURL: true),
                          components.host == "redzone",
                          let day = Int(components.queryItems?.first(where: { $0.name == "setOutlook" })?.value ?? ""),
                          let outlookDay = OutlookDay(rawValue: day) else {
                        Logger.log(.widgets, "Not sure how to handle this URL")
                        return
                    }
                    switch outlookDay {
                    case .day1: outlookType = .convective1(.categorical)
                    case .day2: outlookType = .convective2(.categorical)
                    }
                }
        }
    }
}
