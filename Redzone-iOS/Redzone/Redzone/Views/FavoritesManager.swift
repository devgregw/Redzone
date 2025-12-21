//
//  FavoritesManager.swift
//  Redzone
//
//  Created by Greg Whatley on 10/17/25.
//

import RedzoneCore
import RedzoneUI
import SwiftUI

struct FavoritesManager: View {
    @CodableAppStorage("favorites") private var favoriteOutlooks: [OutlookType] = []
    @Environment(\.editMode) private var editMode
    var body: some View {
        List($favoriteOutlooks, id: \.self, editActions: .all) {
            Text($0.wrappedValue.localizedStringResource)
        }
        .overlay {
            if favoriteOutlooks.isEmpty {
                Text("No favorites yet")
                    .font(.title.weight(.medium))
                    .opacity(0.65)
                    .multilineTextAlignment(.leading)
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            EditButton()
                .disabled(favoriteOutlooks.isEmpty)
        }
        .onChange(of: favoriteOutlooks) {
            if favoriteOutlooks.isEmpty {
                editMode?.wrappedValue = .inactive
            }
        }
    }
}
