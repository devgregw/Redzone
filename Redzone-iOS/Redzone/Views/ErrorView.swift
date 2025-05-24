//
//  ErrorView.swift
//  Redzone
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
            .toolbar {
                DismissButton()
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

#Preview {
    VStack { }
        .sheet(isPresented: .constant(true)) {
            ErrorView(message: "Could not connect to the server.")
        }
}
