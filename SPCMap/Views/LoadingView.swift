//
//  LoadingView.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/7/23.
//

import SwiftUI

fileprivate struct LargeCircularProgressView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 8) {
            LargeCircularProgressView()
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
