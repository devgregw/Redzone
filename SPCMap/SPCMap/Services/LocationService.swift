//
//  LocationService.swift
//  SPCMap
//
//  Created by Greg Whatley on 7/11/23.
//

import Foundation
import CoreLocation
import SwiftUI

@Observable
class LocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager: CLLocationManager
    
    private(set) var lastKnownLocation: CLLocation? = nil
    private(set) var isUpdatingLocation: Bool = false
    
    override init() {
        locationManager = .init()
        super.init()
        
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.delegate = self
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            isUpdatingLocation = true
        }
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        isUpdatingLocation = false
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        isUpdatingLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        isUpdatingLocation = false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.last
    }
}
