//
//  TimeFramePicker.swift
//  SPC
//
//  Created by Greg Whatley on 4/8/23.
//

import SwiftUI

struct TimeFramePicker: View {
    @Binding var timeFrame: Int
    
    var body: some View {
        Picker("Day", selection: $timeFrame) {
            ForEach(1...3, id: \.self) {
                Text("Day \($0)")
            }
        }
    }
}
