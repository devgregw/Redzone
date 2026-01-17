//
//  LocationService.swift
//  RedzoneCore
//
//  Created by Greg Whatley on 9/19/25.
//

internal import Algorithms
import Combine
@preconcurrency import CoreLocation
import Foundation
import OSLog

@Observable @MainActor public final class LocationService: NSObject {
    private static let logger: Logger = .create()

    private static func retrieveStoredLocation() -> CLLocation? {
        guard let data = UserDefaults.standard.data(forKey: "lastKnownLocation") else { return nil }
        guard let location = try? NSKeyedUnarchiver.unarchivedObject(ofClass: CLLocation.self, from: data) else {
            logger.debug("Failed to unarchive stored location")
            return nil
        }
        logger.debug("Retrieved stored location: \(location.debugDescription, privacy: .sensitive)")
        return location
    }

    private static func setStoredLocation(_ location: CLLocation) {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: location, requiringSecureCoding: true) else {
            logger.debug("Failed to archive new location")
            return
        }
        UserDefaults.standard.set(data, forKey: "lastKnownLocation")
    }

    @ObservationIgnored private let manager: CLLocationManager
    @ObservationIgnored private let locationPublisher: CurrentValueSubject<Result<CLLocation?, any Error>, Never>
    @ObservationIgnored private let authorizationPublisher: CurrentValueSubject<CLAuthorizationStatus, Never>
    @ObservationIgnored private let persistLastKnownLocation: Bool
    public var authorizationStatus: CLAuthorizationStatus
    public var lastKnownLocation: CLLocation? {
        didSet {
            if persistLastKnownLocation,
               let lastKnownLocation {
                Self.setStoredLocation(lastKnownLocation)
            }
        }
    }

    public override convenience init() {
        self.init(persistLastKnownLocation: false)
    }

    public init(persistLastKnownLocation: Bool) {
        self.persistLastKnownLocation = persistLastKnownLocation
        self.manager = CLLocationManager()
        self.authorizationStatus = manager.authorizationStatus
        self.locationPublisher = .init(.success(manager.location))
        self.authorizationPublisher = .init(manager.authorizationStatus)
        if persistLastKnownLocation {
            self.lastKnownLocation = [manager.location, Self.retrieveStoredLocation()].compacted().max { $0.timestamp < $1.timestamp }
        } else {
            self.lastKnownLocation = manager.location
        }
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
        if let lastKnownLocation,
           abs(lastKnownLocation.timestamp.timeIntervalSince(.now)) < 30 {
            Self.logger.debug("Recent location already available: \(lastKnownLocation.debugDescription, privacy: .sensitive)")
            return lastKnownLocation
        }
        manager.requestLocation()
        for await result in locationPublisher.values {
            if case let .success(location) = result,
               let location {
                Self.logger.debug("Received location: \(location.debugDescription, privacy: .sensitive)")
                return location
            } else if case .failure = result {
                Self.logger.warning("Location request failed.")
                return lastKnownLocation
            }
        }
        Self.logger.error("Location request did not yield any values before terminating.")
        return lastKnownLocation
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
