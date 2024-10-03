//
//  OpenURLModifier.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/28/24.
//

import SwiftUI

struct OpenURLModifier: ViewModifier {
    @Binding var url: URL?
    
    init(url: Binding<URL?>) {
        self._url = url
    }
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(item: $url) {
                SafariView(url: $0)
                    .ignoresSafeArea()
            }
    }
}

extension URL: @retroactive Identifiable {
    public var id: String { self.absoluteString }
}

extension View {
    func openURL(url: Binding<URL?>) -> some View {
        modifier(OpenURLModifier(url: url))
    }
}
