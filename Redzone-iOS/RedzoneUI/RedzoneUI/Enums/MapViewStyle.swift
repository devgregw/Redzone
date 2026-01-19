//
//  MapViewStyle.swift
//  RedzoneUI
//
//  Created by Greg Whatley on 9/21/25.
//

import Foundation

public enum MapViewStyle: String, CaseIterable, Hashable, Sendable, CustomLocalizedStringResourceConvertible {
    case standard
    case hybrid

    public var localizedStringResource: LocalizedStringResource {
        switch self {
        case .standard: .standard
        case .hybrid: .satellite
        }
    }

    public var systemImage: String {
        switch self {
        case .standard: "map"
        case .hybrid: "globe.americas"
        }
    }
}
