//
//  ErrorView.swift
//  SPC
//
//  Created by Greg Whatley on 6/25/23.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(Image(systemName: "xmark.circle.fill").symbolRenderingMode(.multicolor)) An error occurred")
                            .font(.title3.bold())
                            .padding(.bottom)
                        Spacer()
                    }
                    
                    Text(message)
                }
                .padding([.horizontal, .bottom])
            }
            .navigationTitle("Error")
            .navigationBarTitleDisplayMode(.inline)
        }
        .scrollContentBackground(.hidden)
        .presentationBackground(.ultraThinMaterial)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        VStack { }
            .sheet(isPresented: .constant(true)) {
                ErrorView(message: "Could not connect to the server.")
            }
    }
}
