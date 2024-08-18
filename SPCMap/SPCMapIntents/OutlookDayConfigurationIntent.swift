//
//  OutlookDayConfigurationIntent.swift
//  SPCMapIntents
//
//  Created by Greg Whatley on 4/7/24.
//

import AppIntents
import Foundation
import WidgetKit

// periphery:ignore - Intents are created & used by the system.
struct OutlookDayConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Outlook Day"
    static var description = IntentDescription("Select the day to show outlooks for. Generally, day 1 corresponds to today and day 2 to tomorrow.")
    
    @Parameter(title: "Outlook Day", default: .day1)
    var day: OutlookDay
    
    init(day: OutlookDay) {
        self.day = day
    }
    
    init() {
        
    }
}
