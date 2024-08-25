//
//  Settings.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/8/24.
//

import Foundation
import CoreLocation

class Settings {
    private init() { }
    
    @SettingsStorage(key: .lastKnownLocation, defaultValue: .none)
    static var lastKnownLocation: CLLocationCoordinate2D?
    
    @SettingsStorage(key: .autoMoveCamera, defaultValue: true)
    static var autoMoveCamera: Bool
}

enum SettingsKey: String {
    case lastKnownLocation
    case autoMoveCamera
}

fileprivate let userDefaults: UserDefaults = {
    guard let suite = UserDefaults(suiteName: "group.L586WSJPG7.dev.gregwhatley.SPCMap") else {
        Logger.log(.settings, "Unable to load UserDefaults app group suite")
        return .standard
    }
    return suite
}()

@propertyWrapper struct SettingsStorage<Value: Codable> {
    let key: SettingsKey
    let defaultValue: Value
    
    var wrappedValue: Value {
        get {
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
        set {
            Logger.log(.settings, "Setting value for key \(key.rawValue) of type \(String(describing: Value.self))")
            guard let data = try? JSONEncoder().encode(newValue) else {
                Logger.log(.settings, "Unable to encode value for key \(key.rawValue) of type \(String(describing: Value.self))")
                return
            }
            userDefaults.setValue(data, forKey: key.rawValue)
        }
    }
}
