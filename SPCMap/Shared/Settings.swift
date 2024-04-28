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
}

extension CLLocationCoordinate2D: Codable {
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            latitude: try container.decode(CLLocationDegrees.self, forKey: .latitude),
            longitude: try container.decode(CLLocationDegrees.self, forKey: .longitude)
        )
    }
}

enum SettingsKey: String {
    case lastKnownLocation
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
