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
                    print("Widget: Reloading timeline due to new service state")
                    WidgetCenter.shared.reloadTimelines(ofKind: "SPCMapWidget")
                }
        }
    }
}
