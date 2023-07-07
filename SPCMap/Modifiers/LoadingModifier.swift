//
//  LoadingModifier.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/7/23.
//

import SwiftUI

struct LoadingModifier: ViewModifier {
    let show: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if show {
                LoadingView()
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
