//
//  CodedAppStorage.swift
//  Redzone
//
//  Created by Greg Whatley on 5/25/25.
//

import SwiftUI

@propertyWrapper struct CodedAppStorage<Value: Codable & Sendable>: DynamicProperty, Sendable {
    @AppStorage private var rawValue: Data
    
    init(wrappedValue defaultValue: Value, _ key: String, store: UserDefaults? = nil) {
        self._rawValue = .init(wrappedValue: (try? JSONEncoder().encode(defaultValue)) ?? Data(), key, store: store)
        self.lastValue = defaultValue
    }
    
    private var lastValue: Value
    
    var wrappedValue: Value {
        get {
            lastValue
        }
        nonmutating set {
            do {
                rawValue = try JSONEncoder().encode(newValue)
            } catch { }
        }
    }
    
    var projectedValue: Binding<Value> {
        Binding {
            wrappedValue
        } set: {
            wrappedValue = $0
        }
    }
    
    mutating func update() {
        do {
            lastValue = try JSONDecoder().decode(Value.self, from: rawValue)
        } catch { }
    }
}
