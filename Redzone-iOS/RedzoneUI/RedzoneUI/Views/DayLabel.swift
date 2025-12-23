//
//  DayLabel.swift
//  RedzoneUI
//
//  Created by Greg Whatley on 9/21/25.
//

import SwiftUI

public struct DayLabel: View {
    let day: Int

    public init(day: Int) {
        self.day = day
    }

    public var body: some View {
        Text("Day \(Image(systemName: "\(day).circle"))")
            .font(.footnote)
    }
}

#Preview {
    DayLabel(day: 1)
}
