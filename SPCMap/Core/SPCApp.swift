//
//  SPCMapApp.swift
//  SPCMap
//
//  Created by Greg Whatley on 3/15/23.
//

import SwiftUI

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
        }
    }
}
