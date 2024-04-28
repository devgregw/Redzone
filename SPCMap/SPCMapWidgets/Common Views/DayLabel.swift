//
//  DayLabel.swift
//  SPCMapWidgets
//
//  Created by Greg Whatley on 4/7/24.
//

import SwiftUI

struct DayLabel: View {
    let day: OutlookDay
    
    var body: some View {
        Text("Day \(Image(systemName: "\(day.rawValue).circle"))")
            .font(.footnote)
    }
}
