//
//  WidgetLocation.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/6/24.
//

@preconcurrency import CoreLocation
import Foundation

struct WidgetLocation {
    private final class WidgetLocationDelegate: NSObject, Sendable, CLLocationManagerDelegate {
        let callback: @Sendable (sending CLLocation?) -> Void
        
        init(callback: @Sendable @escaping (CLLocation?) -> Void) {
            self.callback = callback
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            Logger.log(.locationService, "Widget location returned \(locations.count)")
            callback(locations.last)
        }
    }
    
    static func requestLocation() async -> CLLocation? {
        await withCheckedContinuation { continuation in
            let locationManager = CLLocationManager()
            let delegate = WidgetLocationDelegate {
                continuation.resume(returning: $0)
            }
            locationManager.delegate = delegate
            locationManager.requestLocation()
        }
    }
}
