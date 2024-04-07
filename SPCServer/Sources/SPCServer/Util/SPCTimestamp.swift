//
//  SPCTimestamp.swift
//  
//
//  Created by Greg Whatley on 4/6/24.
//

import Foundation

struct SPCTimestamp: Hashable, Equatable {
    private struct SPCDateFormat: FormatStyle {
        typealias FormatInput = Date
        typealias FormatOutput = String
        
        func format(_ value: Date) -> String {
            let components = Calendar.current.dateComponents(in: .gmt, from: value)
            let year = (components.year ?? 0).stringByPaddingZeroes(length: 4)
            let month = (components.month ?? 0).stringByPaddingZeroes(length: 2)
            let day = (components.day ?? 0).stringByPaddingZeroes(length: 2)
            return "\(year)\(month)\(day)"
        }
    }

    private struct SPCTimeFormat: FormatStyle {
        typealias FormatInput = Date
        typealias FormatOutput = Int
        
        func format(_ value: Date) -> Int {
            let components = Calendar.current.dateComponents(in: .gmt, from: value)
            let hour = components.hour ?? 0
            let minute = (components.minute ?? 0).stringByPaddingZeroes(length: 2)
            return Int("\(hour)\(minute)") ?? 0
        }
    }
    
    private let referenceDate: Date
    
    static func == (lhs: SPCTimestamp, rhs: SPCTimestamp) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
        hasher.combine(time)
    }
    
    private init(referenceDate: Date) {
        self.referenceDate = referenceDate
    }
    
    var year: Int {
        Calendar.current.component(.year, from: referenceDate)
    }
    
    var date: String {
        referenceDate.formatted(SPCDateFormat())
    }
    
    var time: Int {
        referenceDate.formatted(SPCTimeFormat())
    }
    
    var timeIntervalSinceNow: TimeInterval {
        referenceDate.timeIntervalSinceNow
    }
    
    static var now: SPCTimestamp {
        SPCTimestamp(referenceDate: .now)
    }
    
    static var yesterday: SPCTimestamp {
        .now.subtract(days: 1)
    }
    
    func subtract(days: Int) -> SPCTimestamp {
        SPCTimestamp(referenceDate: Calendar.current.date(byAdding: .day, value: -days, to: referenceDate)!)
    }
}
