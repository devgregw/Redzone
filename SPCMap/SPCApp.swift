//
//  SPCMapApp.swift
//  SPCMap
//
//  Created by Greg Whatley on 3/15/23.
//

import SwiftUI

@main
struct SPCApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(OutlookService())
        }
    }
}
