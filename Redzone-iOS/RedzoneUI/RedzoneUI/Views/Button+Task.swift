//
//  Button+Task.swift
//  RedzoneUI
//
//  Created by Greg Whatley on 9/21/25.
//

import SwiftUI

public extension Button {
    init(task: @MainActor @escaping () async -> Void, @ViewBuilder label: () -> Label) {
        self.init(action: { Task { await task() } }, label: label)
    }
}
