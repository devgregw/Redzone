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
    @AppStorage(AppStorageKeys.autoMoveCamera) private var autoMoveCamera: Bool = true
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
                    let newOutlook: OutlookType = switch outlookDay {
                    case .day1: .convective1(.categorical)
                    case .day2: .convective2(.categorical)
                    }
                    outlookType = newOutlook
                    if case let .loaded(response) = outlookService.state,
                       response.outlookType == newOutlook {
                        // Manually reload if the widget outlook is the same as the current outlook.
                        // The task modifier will not be re-run because the ID didn't change.
                        Task {
                            await outlookService.refresh()
                            if autoMoveCamera {
                                context.moveCamera(centering: outlookService.state)
                            }
                        }
                    }
                }
        }
    }
}
