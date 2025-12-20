//
//  LocationService.swift
//  RedzoneCore
//
//  Created by Greg Whatley on 9/19/25.
//

@preconcurrency import CoreLocation
import Foundation
import OSLog
import Combine
internal import RedzoneMacros

@Observable @MainActor public final class LocationService: NSObject {
    private static let logger: Logger = .create()

    @ObservationIgnored private let manager: CLLocationManager
    @ObservationIgnored private let locationPublisher: CurrentValueSubject<Result<CLLocation?, any Error>, Never>
    @ObservationIgnored private let authorizationPublisher: CurrentValueSubject<CLAuthorizationStatus, Never>
    public var authorizationStatus: CLAuthorizationStatus
    public var lastKnownLocation: CLLocation?

    public override init() {
        manager = CLLocationManager()
        authorizationStatus = manager.authorizationStatus
        lastKnownLocation = manager.location
        locationPublisher = .init(.success(manager.location))
        authorizationPublisher = .init(manager.authorizationStatus)
        super.init()
        manager.delegate = self
        Self.logger.debug("Location service initialized.")
    }

    public func startUpdating() async {
        _ = await requestLocation()
    }

    private var shouldReuqestAuthorization: Bool {
        #if os(watchOS)
        authorizationStatus == .notDetermined
        #else
        authorizationStatus == .notDetermined || !manager.isAuthorizedForWidgetUpdates
        #endif
    }

    public func requestAuthorization() async -> Bool {
        if shouldReuqestAuthorization {
            Self.logger.debug("Requesting authorization...")
            manager.requestWhenInUseAuthorization()
            for await status in authorizationPublisher.values where status != .notDetermined {
                return status == .authorizedWhenInUse
            }
            Self.logger.error("Authorization request did not yield any values before terminating.")
        } else {
            Self.logger.debug("Skipping authorization request - already known: \(self.authorizationStatus.description)")
        }
        return authorizationStatus == .authorizedWhenInUse
    }

    public func requestLocation() async -> CLLocation? {
        guard await requestAuthorization() else { return nil }
        Self.logger.debug("Requesting location update...")
        manager.requestLocation()
        for await result in locationPublisher.values {
            if case let .success(location) = result,
               let location {
                Self.logger.debug("Received location: \(location.coordinate.latitude, privacy: .sensitive), \(location.coordinate.longitude, privacy: .sensitive)")
                return location
            } else if case .failure = result {
                Self.logger.warning("Location request failed.")
                return nil
            }
        }
        Self.logger.error("Location request did not yield any values before terminating.")
        return nil
    }
}

extension LocationService: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Self.logger.debug("locationManagerDidChangeAuthorization: \(manager.authorizationStatus.description).")
        DispatchQueue.main.async { [weak self] in
            self?.authorizationStatus = manager.authorizationStatus
            self?.authorizationPublisher.send(manager.authorizationStatus)
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async { [weak self] in
            let newest = locations.max { $0.timestamp < $1.timestamp }
            self?.lastKnownLocation = newest
            self?.locationPublisher.send(.success(newest))
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        Self.logger.error("didFailWithError: \(error.localizedDescription)")
        DispatchQueue.main.async { [weak self] in
            self?.locationPublisher.send(.failure(error))
        }
    }
}

extension CLAuthorizationStatus: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
        case .notDetermined: return "Not determined"
        case .restricted: return "Restricted"
        case .denied: return "Denied"
        case .authorizedAlways: return "Authorized (always)"
        case .authorizedWhenInUse: return "Authorized (when in use)"
        @unknown default: return "Unknown"
        }
    }
}
