//
//  CodableAppStorage.swift
//  RedzoneUI
//
//  Created by Greg Whatley on 9/21/25.
//

import RedzoneCore
import SwiftUI

@MainActor @propertyWrapper public struct CodableAppStorage<Value: Codable & Sendable>: Sendable, DynamicProperty {
    @AppStorage private var storedData: Data?
    private let defaultValue: Value
    private let key: String

    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) {
        self.defaultValue = wrappedValue
        self.key = key
        self._storedData = AppStorage(key, store: store)
    }

    public var wrappedValue: Value {
        get {
            guard let data = storedData else { return defaultValue }
            return (try? JSONDecoder().decode(Value.self, from: data)) ?? defaultValue
        }
        nonmutating set {
            storedData = try? JSONEncoder().encode(newValue)
        }
    }

    public var projectedValue: Binding<Value> {
        Binding {
            wrappedValue
        } set: {
            wrappedValue = $0
        }
    }
}
