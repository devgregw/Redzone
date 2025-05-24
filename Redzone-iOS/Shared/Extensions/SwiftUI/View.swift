//
//  View.swift
//  Redzone
//
//  Created by Greg Whatley on 4/8/23.
//

import SwiftUI

extension View {
    func toolbarItem(_ placement: ToolbarItemPlacement = .automatic) -> ToolbarItem<Void, Self> {
        ToolbarItem(placement: placement) {
            self
        }
    }
    
    func onChange<V: Equatable>(of value: V, initial: Bool = false, _ task: @Sendable @escaping () async -> Void) -> some View {
        onChange(of: value, initial: initial, { Task(operation: task) })
    }
}
