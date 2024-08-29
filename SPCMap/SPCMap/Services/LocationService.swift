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
    
    private(set) var lastKnownLocation: CLLocation? = nil {
        didSet {
            stateChangePublisher.send(lastKnownLocation)
        }
    }
    private(set) var isUpdatingLocation: Bool = false
    
    @ObservationIgnored private let stateChangePublisher = PassthroughSubject<CLLocation?, Never>()
    @ObservationIgnored lazy var debouncePublisher: AnyPublisher<CLLocation, Never> = stateChangePublisher
        .filter { $0 != nil }
        .debounce(for: .seconds(30), scheduler: DispatchQueue.main)
        .map {
            Logger.log(.locationService, "Debounce")
            return $0!
        }
        .eraseToAnyPublisher()
    
    override init() {
        defer {
            Logger.log(.locationService, "Initialized")
        }
        locationManager = .init()
        super.init()
        
        #if !os(watchOS)
        locationManager.pausesLocationUpdatesAutomatically = true
        #endif
        locationManager.delegate = self
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
