//
//  RedzoneApp.swift
//  Redzone
//
//  Created by Greg Whatley on 9/21/25.
//

import CoreLocation
import Dependencies
import FirebaseAppCheck
import FirebaseCore
import RedzoneCore
import RedzoneUI
import SwiftUI

extension OutlookService: @retroactive DependencyKey {
    public static let liveValue: OutlookService = .init(adapter: .urlSession {
        try await AppCheck.appCheck().token(forcingRefresh: false).token
    })
#if DEBUG
    public static let previewValue: OutlookService = .init(adapter: .custom {
        if $0.relativePath.contains("fire") {
            Data(contentsOf: Mocks.fire.json)
        } else {
            Data(contentsOf: Mocks[dynamicMember: $0.lastPathComponent].json)
        }
    })
    public static var testValue: OutlookService { previewValue }
#endif
}

@main
struct RedzoneApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
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

private class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
#if targetEnvironment(simulator)
        AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())
#endif
        FirebaseApp.configure()
        return true
    }
}
