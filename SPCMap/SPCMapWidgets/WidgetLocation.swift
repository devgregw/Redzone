//
//  WidgetLocation.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/6/24.
//

import CoreLocation
import Foundation

class WidgetLocation: NSObject, CLLocationManagerDelegate {
    static let shared: WidgetLocation = WidgetLocation()
    
    private let lock = NSLock()
    
    private override init() {
        manager = .init()
        super.init()
        manager.delegate = self
    }
    
    private let manager: CLLocationManager
    
    private var completion: ((CLLocation?) -> Void)?
    
    func requestOneTimeLocation(completion: @escaping (CLLocation?) -> Void) {
        if let lastKnownLocation = Settings.lastKnownLocation {
            completion(.init(latitude: lastKnownLocation.latitude, longitude: lastKnownLocation.longitude))
            return
        }
        lock.lock()
        self.completion = completion
        if !manager.isAuthorizedForWidgetUpdates || manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else {
            manager.requestLocation()
        }
    }
    
    func requestOneTimeLocation() async -> CLLocation? {
        await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                self.requestOneTimeLocation(completion: continuation.resume(returning:))
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if !manager.isAuthorizedForWidgetUpdates || (manager.authorizationStatus != .authorizedWhenInUse && manager.authorizationStatus != .authorizedAlways) {
            completion?(nil)
            completion = nil
            lock.unlock()
        } else {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        completion?(nil)
        completion = nil
        lock.unlock()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Settings.lastKnownLocation = locations.last?.coordinate
        completion?(locations.last)
        completion = nil
        lock.unlock()
    }
}
