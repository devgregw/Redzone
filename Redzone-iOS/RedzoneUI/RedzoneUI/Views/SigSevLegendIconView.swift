//
//  SigSevLegendIconView.swift
//  RedzoneUI
//
//  Created by Greg Whatley on 9/27/25.
//

import SwiftUI

public struct SigSevLegendIconView: View {
    public init() { }
    
    public var body: some View {
        Image(systemName: "circle.dashed")
            .foregroundStyle(.black)
            .shadow(color: .black.opacity(0.5), radius: 10)
            .padding(2)
            .background {
                Circle()
                    .fill(.white)
            }
    }
}

#Preview {
    SigSevLegendIconView()
}
