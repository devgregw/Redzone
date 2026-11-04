//
//  NeverMinimizeNavigationBarModifier.swift
//  RedzoneUI
//
//  Created by Greg Whatley on 11/2/26.
//

import SwiftUI

@available(watchOS, unavailable)
struct NeverMinimizeNavigationBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 27.0, *) {
            content
                .toolbarMinimizationBehavior(.never, for: .navigationBar)
                .toolbarVisibility(.visible, for: .navigationBar)
        } else {
            content
                .toolbarVisibility(.visible, for: .navigationBar)
        }
    }
}

@available(watchOS, unavailable)
public extension View {
    func neverMinimizeNavigationBar() -> some View {
        modifier(NeverMinimizeNavigationBarModifier())
    }
}
