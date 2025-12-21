//
//  OneTimeTaskModifier.swift
//  RedzoneUI
//
//  Created by Greg Whatley on 9/27/25.
//

import SwiftUI

struct OneTimeTaskModifier<ID: Hashable>: ViewModifier {
    @State private var lastRun: (Date, ID)?

    let id: ID
    let priority: TaskPriority
    let timeout: TimeInterval
    let operation: @MainActor () async -> Void

    private var shouldRun: Bool {
        guard let lastRun else { return true }
        return id != lastRun.1 || Date.now >= lastRun.0.addingTimeInterval(timeout)
    }

    func body(content: Content) -> some View {
        content
            .task(id: id, priority: priority) { @MainActor in
                guard shouldRun else { return }
                lastRun = (.now, id)
                await operation()
            }
    }
}

public extension View {
    func task<ID: Hashable>(
        id: ID,
        priority: TaskPriority = .userInitiated,
        timeout: TimeInterval,
        operation: @MainActor @escaping () async -> Void
    ) -> some View {
        modifier(OneTimeTaskModifier(id: id, priority: priority, timeout: timeout, operation: operation))
    }

    func task(
        priority: TaskPriority = .userInitiated,
        timeout: TimeInterval,
        operation: @MainActor @escaping () async -> Void
    ) -> some View {
        modifier(OneTimeTaskModifier(id: 0, priority: priority, timeout: timeout, operation: operation))
    }
}
