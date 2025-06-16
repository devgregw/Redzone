//
//  DismissButton.swift
//  Redzone
//
//  Created by Greg Whatley on 2/9/24.
//

import SwiftUI

struct DismissButton: ToolbarContent {
    @Environment(\.dismiss) private var dismiss
    
    var body: some ToolbarContent {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.title3.bold())
                .symbolRenderingMode(.hierarchical)
        }
        .toolbarItem(.topBarTrailing)
    }
}
