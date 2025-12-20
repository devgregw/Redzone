//
//  ExternalLink.swift
//  RedzoneUI
//
//  Created by Greg Whatley on 9/28/25.
//

import SwiftUI

public struct ExternalLink<Content: View>: View {
    private let url: URL
    private let label: () -> Content
    private let icon: Image?

    public init(_ url: URL, label: LocalizedStringResource, icon: Image? = nil) where Content == Text {
        self.url = url
        self.label = { Text(label) }
        self.icon = icon
    }

    public init(_ url: URL, icon: Image? = nil, @ViewBuilder label: @escaping () -> Content) {
        self.url = url
        self.icon = icon
        self.label = label
    }

    private var labelView: some View {
        HStack {
            VStack(alignment: .leading) {
                label()
    #if os(watchOS)
                    .foregroundStyle(.foreground)
    #else
                    .foregroundStyle(Color(uiColor: .label))
    #endif
                if let host = url.host() {
                    Text(host.trimmingPrefix("www."))
                        .font(.caption)
    #if os(watchOS)
                        .foregroundStyle(.secondary)
    #else
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
    #endif
                }
            }
            Spacer()
            Image(systemName: "arrow.up.forward.square")
                .accessibilityHidden(true)
        }
    }

    public var body: some View {
        Link(destination: url) {
            if let icon {
                Label {
                    labelView
                } icon: {
                    icon
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 35, maxHeight: 35)
                        .accessibilityHidden(true)
                }
            } else {
                labelView
            }
        }
    }
}
