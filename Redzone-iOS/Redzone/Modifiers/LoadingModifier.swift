//
//  LoadingModifier.swift
//  Redzone
//
//  Created by Greg Whatley on 4/7/23.
//

import SwiftUI

struct LoadingModifier: ViewModifier {
    let show: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if show {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(1.5)
                        .padding(24)
                        .transition(.asymmetric(insertion: .identity, removal: .opacity).animation(.easeInOut.speed(1.25)))
                        .clippedBackground()
                }
            }
    }
}

extension View {
    func loading<T>(when variable: T, equals value: T) -> some View where T: Equatable {
        self.modifier(LoadingModifier(show: variable == value))
    }
    
    func loading(if bool: Bool) -> some View {
        self.loading(when: bool, equals: true)
    }
}

#Preview {
    VStack { }
        .loading(if: true)
}
