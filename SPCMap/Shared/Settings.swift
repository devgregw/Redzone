//
//  Settings.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/8/24.
//

import Foundation
import CoreLocation

@MainActor final class Settings {
    private static let userDefaults: UserDefaults = {
        if let suite = UserDefaults(suiteName: "group.L586WSJPG7.dev.gregwhatley.SPCMap") {
            return suite
        } else {
            Logger.log(.settings, "Unable to load UserDefaults app group suite")
            return .standard
        }
    }()
    
    private static func getSetting<Value: Codable>(key: SettingsKey, defaultValue: Value) -> Value {
        guard let data = userDefaults.data(forKey: key.rawValue) else {
            Logger.log(.settings, "Value for key \(key.rawValue) of type \(String(describing: Value.self)) does not exist")
            return defaultValue
        }
        Logger.log(.settings, "Retrieving value for key \(key.rawValue) of type \(String(describing: Value.self))")
        do {
            return try JSONDecoder().decode(Value.self, from: data)
        } catch {
            Logger.log(.settings, "Unable to decode value for key \(key.rawValue) of type \(String(describing: Value.self))")
            return defaultValue
        }
    }
    
    private static func setSetting<Value: Codable>(key: SettingsKey, newValue: Value) {
        Logger.log(.settings, "Setting value for key \(key.rawValue) of type \(String(describing: Value.self))")
        guard let data = try? JSONEncoder().encode(newValue) else {
            Logger.log(.settings, "Unable to encode value for key \(key.rawValue) of type \(String(describing: Value.self))")
            return
        }
        userDefaults.setValue(data, forKey: key.rawValue)
    }
    
    static var lastKnownLocation: CLLocationCoordinate2D? {
        get { getSetting(key: .lastKnownLocation, defaultValue: .none) }
        set { setSetting(key: .lastKnownLocation, newValue: newValue) }
    }
    
    static var autoMoveCamera: Bool {
        get { getSetting(key: .autoMoveCamera, defaultValue: true) }
        set { setSetting(key: .autoMoveCamera, newValue: newValue) }
    }
}

enum SettingsKey: String {
    case lastKnownLocation
    case autoMoveCamera
}
