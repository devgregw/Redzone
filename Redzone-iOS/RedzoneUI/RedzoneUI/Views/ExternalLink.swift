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
    private let icon: () -> Image?

    public init(_ url: URL, label: LocalizedStringResource, icon: @autoclosure @escaping () -> Image? = nil) where Content == Text {
        self.url = url
        self.label = { Text(label) }
        self.icon = icon
    }

    public init(_ url: URL, icon: @autoclosure @escaping () -> Image? = nil, @ViewBuilder label: @escaping () -> Content) {
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
            #if EXTERNALLINK_LOGOS
            Image(systemName: "arrow.up.forward.square")
                .accessibilityHidden(true)
            #endif
        }
    }

    public var body: some View {
        Link(destination: url) {
#if EXTERNALLINK_LOGOS
            if let icon: Image = icon() {
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
#else
            Label {
                labelView
            } icon: {
                Image(systemName: "arrow.up.forward.square")
                    .accessibilityHidden(true)
            }
#endif
        }
    }
}

#Preview {
    // swiftlint:disable:next force_unwrapping
    ExternalLink(URL(string: "https://example.com")!, icon: .init(systemName: "xmark")) {
        Text("Example")
    }
}
