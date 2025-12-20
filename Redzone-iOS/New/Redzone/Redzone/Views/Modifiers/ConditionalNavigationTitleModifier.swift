//
//  ConditionalNavigationTitleModifier.swift
//  Redzone
//
//  Created by Greg Whatley on 10/2/25.
//

import SwiftUI

fileprivate struct ConditionalNavigationTitleModifier: ViewModifier {
    let title: LocalizedStringResource
    let displayMode: NavigationBarItem.TitleDisplayMode
    let isEnabled: Bool

    func body(content: Content) -> some View {
        if isEnabled {
            content
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(displayMode)
        } else {
            content
        }
    }
}

extension View {
    func navigationTitle(_ title: LocalizedStringResource, displayMode: NavigationBarItem.TitleDisplayMode, isEnabled: Bool) -> some View {
        modifier(ConditionalNavigationTitleModifier(title: title, displayMode: displayMode, isEnabled: isEnabled))
    }
}
