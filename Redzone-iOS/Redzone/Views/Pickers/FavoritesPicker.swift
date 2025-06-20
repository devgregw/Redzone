//
//  FavoritesPicker.swift
//  Redzone
//
//  Created by Greg Whatley on 6/19/25.
//

import SwiftUI

struct FavoritesPicker: View {
    @CodedAppStorage(AppStorageKeys.outlookType) private var outlookType: OutlookType = .convective1(.categorical)
    @CodedAppStorage(AppStorageKeys.favoriteOutlooks) private var favoriteOutlooks: [OutlookType] = []
    @Environment(Context.self) private var context
    
    var body: some View {
        Menu {
            Section {
                if !favoriteOutlooks.isEmpty {
                    ForEach(favoriteOutlooks, id: \.hashValue) { favorite in
                        Button {
                            outlookType = favorite
                        } label: {
                            if outlookType == favorite {
                                Label(favorite.title, systemImage: "checkmark")
                            } else {
                                Text(favorite.title)
                            }
                            
                        }
                        .accessibilityAddTraits(outlookType == favorite ? .isSelected : [])
                    }
                } else {
                    Text("No Favorites")
                }
            }
            
            Section {
                @Bindable var context = context
                
                if favoriteOutlooks.contains(outlookType) {
                    Button {
                        favoriteOutlooks.remove(outlookType)
                    } label: {
                        Label("Remove Favorite", systemImage: "star.slash")
                        Text(outlookType.title)
                    }
                } else {
                    Button {
                        favoriteOutlooks.append(outlookType)
                    } label: {
                        Label("Add Favorite", systemImage: "plus")
                        Text(outlookType.title)
                    }
                }
                
                if !favoriteOutlooks.isEmpty {
                    Button("Edit Favorites", systemImage: "list.star") {
                        context.displayFavoritesSheet.toggle()
                    }
                }
            }
        } label: {
            Label("Favorites", systemImage: "star")
        }
    }
}
