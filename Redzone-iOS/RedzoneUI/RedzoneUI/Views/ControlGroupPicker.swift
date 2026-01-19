//
//  ControlGroupPicker.swift
//  RedzoneUI
//
//  Created by Greg Whatley on 1/19/26.
//

import SwiftUI

@available(watchOS, unavailable)
public struct ControlGroupPicker<Value: Hashable & Sendable, Content: View>: View {
    let title: String
    @Binding var selection: Value
    let content: Content

    public init(_ titleKey: LocalizedStringResource, selection: Binding<Value>, @ViewBuilder content: () -> Content) {
        self.init(.init(localized: titleKey), selection: selection, content: content)
    }

    public init(_ title: String, selection: Binding<Value>, @ViewBuilder content: () -> Content) {
        self.title = title
        self._selection = selection
        self.content = content()
    }

    public var body: some View {
        ControlGroup(title) {
            ForEach(subviews: content) { subview in
                if let tag = subview.containerValues.tag(for: Value.self) {
                    Toggle(isOn: $selection.mapEquals(tag)) {
                        subview
                    }
                }
            }
        }
    }
}
