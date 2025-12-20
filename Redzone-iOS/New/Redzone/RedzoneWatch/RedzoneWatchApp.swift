//
//  RedzoneWatchApp.swift
//  RedzoneWatch Watch App
//
//  Created by Greg Whatley on 9/21/25.
//

import SwiftUI
import Combine
import Dependencies
import RedzoneCore

extension OutlookService: @retroactive DependencyKey {
    public static let liveValue: OutlookService = .init(adapter: .urlSession)
#if DEBUG
    public static let previewValue: OutlookService = .init(adapter: .custom {
        Data(contentsOf: Mocks[dynamicMember: $0.lastPathComponent].geojson)
    })
    public static var testValue: OutlookService { previewValue }
#endif
}

@main
struct RedzoneApp: App {
    @AppStorage("didAcknowledgeDisclaimer") private var didAcknowledgeDisclaimer = false
    @State private var locationService = LocationService()

    var body: some Scene {
        WindowGroup {
            Group {
                if !didAcknowledgeDisclaimer {
                    ScrollView {
                        Text("Please open Redzone on your iPhone and acknowledge the first launch disclaimer.")
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                } else {
                    ContentView()
                        .environment(locationService)
                        .task {
                            await locationService.startUpdating()
                        }
                }
            }
            .onReceiveApplicationContext(key: "didAcknowledgeDisclaimer", as: Bool.self) {
                didAcknowledgeDisclaimer = $0
            }
        }
    }
}
