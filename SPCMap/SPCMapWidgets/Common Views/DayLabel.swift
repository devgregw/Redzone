//
//  DayLabel.swift
//  SPCMapWidgets
//
//  Created by Greg Whatley on 4/7/24.
//

import SwiftUI
import WidgetKit

struct DayLabel: View {
    let day: OutlookDay
    
    var body: some View {
        Text("Day \(Image(systemName: "\(day.rawValue).circle"))")
            .font(.footnote)
    }
}

#if DEBUG
struct DayLabel_Previews: PreviewProvider {
    static var previews: some View {
        DayLabel(day: .day1)
            .widgetPreview()
    }
}
#endif
