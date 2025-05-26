//
//  Button.swift
//  Redzone
//
//  Created by Greg Whatley on 2/11/24.
//

import SwiftUI

extension Button {
    init(action: @escaping @Sendable () async -> Void, @ViewBuilder label: () -> Label) {
        self.init(action: { Task(operation: action) }, label: label)
    }
}
