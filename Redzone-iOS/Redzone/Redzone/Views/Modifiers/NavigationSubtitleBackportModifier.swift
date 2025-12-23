//
//  NavigationSubtitleBackportModifier.swift
//  Redzone
//
//  Created by Greg Whatley on 10/2/25.
//

import SwiftUI

private struct NavigationTitleSubtitleBackportModifier: ViewModifier {
    let title: LocalizedStringResource
    let subtitle: LocalizedStringResource

    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .navigationTitle(title)
                .navigationSubtitle(subtitle)
        } else {
            content
                .navigationTitle(subtitle)
        }
    }
}

extension View {
    func navigationTitleSubtitleBackport(title: LocalizedStringResource, subtitle: LocalizedStringResource) -> some View {
        modifier(NavigationTitleSubtitleBackportModifier(title: title, subtitle: subtitle))
    }
}
