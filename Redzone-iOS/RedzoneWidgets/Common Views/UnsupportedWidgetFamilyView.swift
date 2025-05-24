//
//  UnsupportedWidgetFamilyView.swift
//  RedzoneWidgets
//
//  Created by Greg Whatley on 8/20/24.
//

import SwiftUI

struct UnsupportedWidgetFamilyView: View {
    var body: some View {
        #if DEBUG
        Image(systemName: "engine.combustion.badge.exclamationmark.fill")
            .font(.largeTitle)
            .symbolRenderingMode(.multicolor)
        #else
        EmptyView()
        #endif
    }
}
