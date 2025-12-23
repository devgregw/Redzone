//
//  NavigationBarBackgroundHiddenModifier.swift
//  RedzoneUI
//
//  Created by Greg Whatley on 9/21/25.
//

import SwiftUI

@available(watchOS, unavailable)
struct NavigationBarBackgroundHiddenModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
    }
}

@available(watchOS, unavailable)
public extension View {
    func navigationBarBackgroundHidden() -> some View {
        modifier(NavigationBarBackgroundHiddenModifier())
    }
}
