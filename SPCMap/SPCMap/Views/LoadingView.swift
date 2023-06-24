//
//  LoadingView.swift
//  SPC
//
//  Created by Greg Whatley on 4/7/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 8) {
            ProgressView()
                .progressViewStyle(.circular)
                .frame(width: 50, height: 50)
                .padding([.horizontal, .top])
            
            Text("Loading...")
                .padding([.horizontal, .bottom])
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .transition(.opacity)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
