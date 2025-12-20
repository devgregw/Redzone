//
//  FavoritesPicker.swift
//  Redzone
//
//  Created by Greg Whatley on 10/17/25.
//

import SwiftUI
import RedzoneCore
import RedzoneUI

struct FavoritesPicker: View {
    @CodableAppStorage("favorites") private var favoriteOutlooks: [OutlookType] = []
    @Binding var selection: OutlookType

    var body: some View {
        Menu("Favorites", systemImage: "star") {
            Section {
                if favoriteOutlooks.isEmpty {
                    Text("No favorites yet")
                } else {
                    ForEach(favoriteOutlooks, id: \.hashValue) {
                        SelectionButton(selection: $selection, value: $0)
                    }
                }
            }
            Section {
                if favoriteOutlooks.contains(selection) {
                    Button {
                        favoriteOutlooks.removeAll { $0 == selection }
                    } label: {
                        Label(selection.localizedStringResource, systemImage: "star.slash")
                    }
                } else {
                    Button {
                        favoriteOutlooks.append(selection)
                    } label: {
                        Label(selection.localizedStringResource, systemImage: "plus")
                    }
                }
                if !favoriteOutlooks.isEmpty {
                    NavigationLink {
                        FavoritesManager()
                    } label: {
                        Label("Manage Favorites", systemImage: "list.star")
                    }
                }
            }
        }
    }
}
