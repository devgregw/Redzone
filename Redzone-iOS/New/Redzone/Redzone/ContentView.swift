//
//  ContentView.swift
//  Redzone
//
//  Created by Greg Whatley on 9/21/25.
//

import CoreLocation
import Dependencies
import SwiftUI
import RedzoneUI
import RedzoneCore

struct ContentView: View {
    var body: some View {
        NavigationStack {
            OutlookMap()
        }
    }
}

#Preview {
    ContentView()
}
