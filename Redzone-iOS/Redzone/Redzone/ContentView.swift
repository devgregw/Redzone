//
//  ContentView.swift
//  Redzone
//
//  Created by Greg Whatley on 9/21/25.
//

import CoreLocation
import Dependencies
import RedzoneCore
import RedzoneUI
import SwiftUI

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
