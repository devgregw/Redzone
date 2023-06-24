//
//  SigSevereBadgeView.swift
//  SPC
//
//  Created by Greg Whatley on 4/8/23.
//

import SwiftUI

struct SigSevereBadgeView: View {
    enum Theme {
        case light
        case dark
        
        fileprivate var backgroundColor: Color {
            if self == .light {
                return .white
            } else {
                return .black
            }
        }
        
        fileprivate var foregroundColor: Color {
            if self == .light {
                return .black
            } else {
                return .white
            }
        }
    }
    
    let theme: Theme
    let font: Font
    
    init(theme: Theme, font: Font) {
        self.theme = theme
        self.font = font.bold()
    }
    
    var body: some View {
        Text("\(Image(systemName: "circle.dashed")) SIG \(Image(systemName: "exclamationmark.triangle.fill").symbolRenderingMode(.multicolor))")
            .foregroundColor(theme.foregroundColor)
            .font(font)
            .padding(2)
            .background(theme.backgroundColor, in: RoundedRectangle(cornerRadius: 8))
            .transition(.scale)
    }
}

struct SigSevereBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SigSevereBadgeView(theme: .dark, font: .body)
            SigSevereBadgeView(theme: .dark, font: .caption)
            SigSevereBadgeView(theme: .light, font: .body)
            SigSevereBadgeView(theme: .light, font: .caption)
        }
    }
}
