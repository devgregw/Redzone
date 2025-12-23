//
//  ApplicationContextModifier.swift
//  RedzoneCore
//
//  Created by Greg Whatley on 12/19/25.
//

import SwiftUI

public extension View {
    // swiftlint:disable:next orphaned_doc_comment
    /// Adds an action to perform when this view receives an update to the specified application context key.
    // periphery:ignore:parameters as - type argument is required for type inference
    func onReceiveApplicationContext<T: AtomicPropertyListValue>(
        key: String,
        as type: T.Type,
        perform action: @escaping @MainActor (T) -> Void
    ) -> some View {
        self
            .onReceive(
                ApplicationContextManager.shared.publisher(for: key, type: T.self),
                perform: action
            )
    }

    /// Updates the specified application context key with the given value.
    func applicationContext<T: AtomicPropertyListValue>(key: String, value: T, initial: Bool = true) -> some View {
        self
            .onChange(of: value, initial: initial) {
                ApplicationContextManager.shared.updateContext(key: key, value: value)
            }
    }
}
