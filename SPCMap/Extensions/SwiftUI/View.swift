//
//  View.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/8/23.
//

import SwiftUI

extension View {
    func toolbarItem(_ placement: ToolbarItemPlacement = .automatic) -> ToolbarItem<Void, Self> {
        ToolbarItem(placement: placement) {
            self
        }
    }
}
