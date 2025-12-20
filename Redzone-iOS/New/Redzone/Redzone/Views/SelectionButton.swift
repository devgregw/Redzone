//
//  SelectionButton.swift
//  Redzone
//
//  Created by Greg Whatley on 10/17/25.
//

import SwiftUI

struct SelectionButton<Value: Equatable>: View {
    @Binding var selection: Value
    let value: Value
    let label: String

    init(selection: Binding<Value>, value: Value, label: LocalizedStringResource) {
        self._selection = selection
        self.value = value
        self.label = .init(localized: label)
    }

    init(selection: Binding<Value>, value: Value) where Value: CustomLocalizedStringResourceConvertible {
        self._selection = selection
        self.value = value
        self.label = .init(localized: value.localizedStringResource)
    }

    var body: some View {
        Button {
            selection = value
        } label: {
            if selection == value {
                Label(label, systemImage: "checkmark")
            } else {
                Text(label)
            }
        }
        .accessibilityAddTraits(selection == value ? [.isSelected] : [])
    }
}
