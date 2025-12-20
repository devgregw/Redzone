//
//  RedzoneApp.swift
//  Redzone
//
//  Created by Greg Whatley on 9/21/25.
//

import CoreLocation
import Dependencies
import RedzoneCore
import RedzoneUI
import SwiftUI

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
    @AppStorage("didAcknowledgeDisclaimer") private var didAcknowledgeDisclaimer: Bool = false
    @State private var locationService = LocationService()

    var body: some Scene {
        WindowGroup {
            Group {
                if didAcknowledgeDisclaimer {
                    ContentView()
                        .environment(locationService)
                        .task {
                            await locationService.startUpdating()
                        }
                } else {
                    FirstLaunchView(didAcknowledgeDisclaimer: $didAcknowledgeDisclaimer)
                }
            }
            .applicationContext(key: "didAcknowledgeDisclaimer", value: didAcknowledgeDisclaimer)
        }
    }
}
