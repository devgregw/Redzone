//
//  LocationService.swift
//  SPCMap
//
//  Created by Greg Whatley on 7/11/23.
//

import Combine
import Foundation
import CoreLocation
import SwiftUI

@Observable
class LocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager: CLLocationManager
    
    private(set) var lastKnownLocation: CLLocation?
    private(set) var isUpdatingLocation: Bool = false
    
    @MainActor override init() {
        Logger.log(.locationService, "Initializing")
        locationManager = .init()
        super.init()
        
        #if !os(watchOS)
        locationManager.pausesLocationUpdatesAutomatically = true
        #endif
        locationManager.delegate = self
        Logger.log(.locationService, "Initialized")
    }
    
    func requestPermission() {
        Logger.log(.locationService, "Requesting when in use authorization")
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Logger.log(.locationService, "Did change authorization \(String(describing: manager.authorizationStatus))")
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            isUpdatingLocation = true
        }
    }
    
    #if !os(watchOS)
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        Logger.log(.locationService, "Did pause location updates")
        isUpdatingLocation = false
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        Logger.log(.locationService, "Did resume location updates")
        isUpdatingLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        Logger.log(.locationService, "Finish deferred updates with error: \(error?.localizedDescription ?? "nil") (\(String(describing: type(of: error))))")
        isUpdatingLocation = false
    }
    #endif
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.last
    }
}
