//
//  SigSevLegendIconView.swift
//  SPCMap
//
//  Created by Greg Whatley on 2/11/24.
//

import SwiftUI

struct SigSevLegendIconView: View {
    var body: some View {
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
