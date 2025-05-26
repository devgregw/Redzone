//
//  LocationService.swift
//  Redzone
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
    @ObservationIgnored private let locationUpdateSubject = PassthroughSubject<CLLocation?, Never>()
    @ObservationIgnored private var cancellable: AnyCancellable?
    
    @MainActor override init() {
        Logger.log(.locationService, "Initializing")
        locationManager = .init()
        super.init()
        
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.delegate = self
        cancellable = locationUpdateSubject
            .filter { $0 != nil }
            .throttle(for: .seconds(30), scheduler: DispatchQueue.global(), latest: true)
            .receive(on: DispatchQueue.main)
            .assign(to: \.lastKnownLocation, on: self)
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if lastKnownLocation.isNil {
            lastKnownLocation = locations.last
        }
        locationUpdateSubject.send(locations.last)
    }
}
