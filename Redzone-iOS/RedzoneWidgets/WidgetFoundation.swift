//
//  WidgetFoundation.swift
//  RedzoneWidgets
//
//  Created by Greg Whatley on 8/18/24.
//

import Foundation
import SwiftUI
import WidgetKit

enum WidgetFoundation {
    protocol EntryData: Hashable {
        static var preview: Self { get }
        // periphery:ignore - False positive.
        static var none: Self { get }
        
        var date: Date { get }
        var url: CommonURL? { get }
    }
    
    enum Entry<EntryData: WidgetFoundation.EntryData>: TimelineEntry, Hashable {
        case success(EntryData)
        case placeholder
        case error(EntryError)
        case preview
        
        var date: Date {
            if case let .success(data) = self {
                return data.date
            } else {
                return .now
            }
        }
    }
    
    enum EntryError: Error, Hashable, CaseIterable {
        case noLocation
        case unknown
    }
    
    protocol Provider {
        associatedtype EntryData: WidgetFoundation.EntryData
        associatedtype Entry = WidgetFoundation.Entry<EntryData>
    }
    
    @MainActor protocol EntryView: View {
        associatedtype Provider: WidgetFoundation.Provider
        associatedtype MainContent: View
        associatedtype PlaceholderContent: View
        associatedtype ErrorContent: View
        
        var entry: Provider.Entry { get }
        
        @ViewBuilder func mainContent(data: Provider.EntryData) -> MainContent
        @ViewBuilder var placeholderContent: PlaceholderContent { get }
        @ViewBuilder func errorContent(error: WidgetFoundation.EntryError) -> ErrorContent
    }
}

extension WidgetFoundation.EntryData {
    var url: CommonURL? { .none }
}

extension WidgetFoundation.EntryView where Provider.Entry == WidgetFoundation.Entry<Provider.EntryData> {
    @ViewBuilder var body: some View {
        switch entry {
        case let .success(data):
            mainContent(data: data)
                .widgetURL(data.url?.rawValue)
        case .placeholder:
            placeholderContent
        case .preview:
            mainContent(data: Provider.EntryData.preview)
        case let .error(error):
            errorContent(error: error)
        }
    }
}

extension WidgetFoundation.EntryView where PlaceholderContent == ModifiedContent<MainContent, _EnvironmentKeyTransformModifier<RedactionReasons>> {
    var placeholderContent: PlaceholderContent {
        mainContent(data: Self.Provider.EntryData.preview)
            .redacted(reason: .placeholder) as! ModifiedContent<MainContent, _EnvironmentKeyTransformModifier<RedactionReasons>>
    }
}

extension WidgetFoundation.EntryView where ErrorContent == WidgetErrorView {
    func errorContent(error: WidgetFoundation.EntryError) -> ErrorContent {
        WidgetErrorView(error: error)
    }
}
