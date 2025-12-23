//
//  NavigationBarTitleHiddenModifier.swift
//  Redzone
//
//  Created by Greg Whatley on 9/1/25.
//

import SwiftUI

@available(watchOS, unavailable)
struct NavigationBarTitleHiddenModifier: ViewModifier {
    let hidden: Bool

    func body(content: Content) -> some View {
        if #available(iOS 26.0, *),
           hidden {
            content
                .toolbar(removing: .title)
        } else if hidden {
            content
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("")
                            .hidden()
                            .accessibilityHidden(true)
                    }
                }
        } else {
            content
        }
    }
}

@available(watchOS, unavailable)
public extension View {
    func navigationBarTitleHidden(_ hidden: Bool = true) -> some View {
        modifier(NavigationBarTitleHiddenModifier(hidden: hidden))
    }
}
