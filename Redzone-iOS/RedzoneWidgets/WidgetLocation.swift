//
//  WidgetLocation.swift
//  Redzone
//
//  Created by Greg Whatley on 4/6/24.
//

@preconcurrency import CoreLocation
import Foundation

struct WidgetLocation {
    static func requestLocation() async -> CLLocation? {
        do {
            for try await update in CLLocationUpdate.liveUpdates().prefix(10) {
                if let location = update.location {
                    Logger.log(.locationService, "Widget location: \(String(describing: update.location))")
                    return location
                }
            }
            Logger.log(.locationService, "Error: No location update received after 10 attempts.")
            return nil
        } catch {
            Logger.log(.locationService, "Widget location error: \(error.localizedDescription)")
            return nil
        }
    }
}
