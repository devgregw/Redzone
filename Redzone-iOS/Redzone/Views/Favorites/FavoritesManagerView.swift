//
//  FavoritesManagerView.swift
//  Redzone
//
//  Created by Greg Whatley on 6/19/25.
//

import SwiftUI

struct FavoritesManagerView: View {
    @CodedAppStorage(AppStorageKeys.outlookType) private var outlookType: OutlookType = .convective1(.categorical)
    @CodedAppStorage(AppStorageKeys.favoriteOutlooks) private var favoriteOutlooks: [OutlookType] = []
    
    var body: some View {
        NavigationStack {
            Group {
                if favoriteOutlooks.isEmpty {
                    VStack {
                        Spacer()
                        Text("No Favorites")
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemGroupedBackground))
                } else {
                    List($favoriteOutlooks, id: \.hashValue, editActions: [.delete, .move]) {
                        Text($0.wrappedValue.title)
                    }
                    .toolbar {
                        EditButton()
                    }
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.inline)
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}
