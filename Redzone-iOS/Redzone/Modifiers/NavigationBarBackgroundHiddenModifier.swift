//
//  NavigationBarBackgroundHiddenModifier.swift
//  Redzone
//
//  Created by Greg Whatley on 6/15/25.
//

import SwiftUI

struct NavigationBarBackgroundHiddenModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            content
                .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
        } else {
            content
                .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}

extension View {
    func navigationBarBackgroundHidden() -> some View {
        modifier(NavigationBarBackgroundHiddenModifier())
    }
}
