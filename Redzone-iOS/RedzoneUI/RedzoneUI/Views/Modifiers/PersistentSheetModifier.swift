//
//  PersistentSheetModifier.swift
//  Redzone
//
//  Created by Greg Whatley on 9/1/25.
//

import SwiftUI

@available(watchOS, unavailable)
public enum PersistentSheetState: Hashable, Sendable {
    case collapsed
    case expanded(detent: PresentationDetent)

    var isExpanded: Bool {
        if case .expanded = self {
            true
        } else {
            false
        }
    }
}

@available(watchOS, unavailable)
struct PersistentSheetModifier<Collapsed: View, Expanded: View>: ViewModifier {
    let collapsedHeight: CGFloat
    let detents: [PresentationDetent]
    let disabled: Bool
    let collapsed: () -> Collapsed
    let expanded: () -> Expanded
    let action: (() -> Void)?

    @Binding private var state: PersistentSheetState
    @State private var navigationStackID: Date = .now
    @State private var isOpen: Bool = false

    private var selectedDetent: Binding<PresentationDetent> {
        Binding {
            switch state {
            case .collapsed: .height(collapsedHeight)
            case let .expanded(detent): detent
            }
        } set: {
            if detents.contains($0) {
                state = .expanded(detent: $0)
            } else {
                state = .collapsed
            }
        }
    }

    init(
        state: Binding<PersistentSheetState>,
        collapsedHeight: CGFloat,
        detents: [PresentationDetent],
        disabled: Bool,
        @ViewBuilder collapsed: @escaping () -> Collapsed,
        @ViewBuilder expanded: @escaping () -> Expanded,
        action: (() -> Void)?
    ) {
        self._state = state
        self.collapsedHeight = collapsedHeight
        self.detents = detents
        self.disabled = disabled
        self.collapsed = collapsed
        self.expanded = expanded
        self.action = action
    }

    func body(content: Content) -> some View {
        content
            .safeAreaPadding(.bottom, collapsedHeight)
            .onChange(of: disabled) {
                if disabled {
                    selectedDetent.wrappedValue = .height(collapsedHeight)
                }
            }
            .onChange(of: collapsedHeight) { old, new in
                if selectedDetent.wrappedValue == .height(old) {
                    selectedDetent.wrappedValue = .height(new)
                }
            }
            .onChange(of: state.isExpanded) { wasExpanded, isExpanded in
                if !isExpanded,
                   wasExpanded {
                    navigationStackID = .now
                }
            }
            .onAppear {
                isOpen = true
            }
            .onDisappear {
                isOpen = false
            }
            .sheet(isPresented: $isOpen) {
                sheetContent
            }
    }

    private var sheetContent: some View {
        NavigationStack {
            if !disabled {
                expanded()
                    .containerBackground(.clear, for: .navigation)
                    .scrollContentBackground(.hidden)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarTitleHidden(!state.isExpanded)
            }
        }
        .id(navigationStackID)
        .overlay(alignment: .top) {
            if !state.isExpanded {
                Button {
                    guard let detent = detents.first else { return }
                    action?()
                    selectedDetent.wrappedValue = detent
                } label: {
                    collapsed()
                        .frame(height: collapsedHeight, alignment: .center)
                }
                .buttonStyle(.plain)
            }
        }
        .contentTransition(.opacity)
        .animation(.interactiveSpring, value: state.isExpanded)
        .interactiveDismissDisabled()
        .presentationDragIndicator(disabled ? .hidden : .visible)
        .presentationBackgroundInteraction(.enabled(upThrough: .height(collapsedHeight)))
        .modifier(PresentationBackgroundHiddenModifier())
        .presentationDetents(disabled ? [.height(collapsedHeight)] : Set(detents).union([.height(collapsedHeight)]), selection: selectedDetent)
        .presentationCompactAdaptation(.sheet)
    }

    private struct PresentationBackgroundHiddenModifier: ViewModifier {
        func body(content: Content) -> some View {
            if #available(iOS 26.0, *) {
                content
                    .presentationBackground(.clear)
            } else {
                content
                    .presentationBackground(.ultraThinMaterial)
            }
        }
    }
}

@available(watchOS, unavailable)
public extension View {
    func persistentSheet<Collapsed: View, Expanded: View>(
        state: Binding<PersistentSheetState>,
        collapsedHeight: CGFloat,
        detents: [PresentationDetent] = [.medium, .large],
        disabled: Bool,
        @ViewBuilder collapsed: @escaping () -> Collapsed,
        @ViewBuilder expanded: @escaping () -> Expanded,
        action: (() -> Void)? = nil
    ) -> some View {
            self.modifier(PersistentSheetModifier(
                state: state,
                collapsedHeight: collapsedHeight,
                detents: detents,
                disabled: disabled,
                collapsed: collapsed,
                expanded: expanded,
                action: action
            ))
    }
}
