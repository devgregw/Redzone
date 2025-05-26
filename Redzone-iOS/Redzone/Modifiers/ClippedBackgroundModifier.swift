//
//  ClippedBackgroundModifier.swift
//  Redzone
//
//  Created by Greg Whatley on 5/25/25.
//

import SwiftUI

struct ClippedBackgroundModifier<S: Shape, Background: ShapeStyle, Stroke: ShapeStyle>: ViewModifier {
    let shape: S
    let background: Background
    let stroke: Stroke
    
    init(_ shape: S, background: Background, stroke: Stroke) {
        self.shape = shape
        self.background = background
        self.stroke = stroke
    }
    
    func body(content: Content) -> some View {
        content
            .background(background)
            .clipShape(shape)
            .overlay {
                shape
                    .stroke(stroke, lineWidth: 0.5)
            }
            .shadow(radius: 8)
    }
}

extension View {
    func clippedBackground<S: Shape, Background: ShapeStyle, Stroke: ShapeStyle>(
        _ shape: S = .rect(cornerRadius: 16),
        background: Background = .thinMaterial,
        stroke: Stroke = Color(.separator)
    ) -> some View {
        modifier(ClippedBackgroundModifier(shape, background: background, stroke: stroke))
    }
}
