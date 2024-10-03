//
//  CombinedRisks.swift
//  SPCMap
//
//  Created by Greg Whatley on 10/2/24.
//

import GeoJSON

struct CombinedRisks: CustomStringConvertible, Hashable {
    struct RiskInfo: CustomStringConvertible, Hashable {
        let percentage: Int
        let isSignificant: Bool
        
        init(percentage: Int, isSignificant: Bool) {
            self.percentage = percentage
            self.isSignificant = isSignificant
        }
        
        init(feature: GeoJSONFeature?, significantFeature: GeoJSONFeature?) {
            self.init(percentage: Self.getPercentage(from: feature), isSignificant: significantFeature?.outlookProperties.isSignificant ?? false)
        }
        
        var description: String {
            "\(percentage)\(isSignificant ? "S" : "")"
        }
        
        private static func getPercentage(from outlook: GeoJSONFeature?) -> Int {
            guard let title = outlook?.outlookProperties.title,
                  title.first?.isNumber == true,
                  let component = title.split(separator: " ").first?.dropLast(1),
                  let intValue = Int(String(component)) else {
                return .zero
            }
            return intValue
        }
        
        static var none: RiskInfo {
            .init(percentage: 0, isSignificant: false)
        }
    }
    
    let wind: RiskInfo
    let hail: RiskInfo
    let tornado: RiskInfo
    
    var anySignificant: Bool {
        wind.isSignificant || hail.isSignificant || tornado.isSignificant
    }
    
    var anyForecast: Bool {
        wind.percentage > .zero || hail.percentage > .zero || tornado.percentage > .zero
    }
    
    var description: String {
        "W\(wind.description)/H\(hail.description)/T\(tornado.description)"
    }
    
    init(wind: RiskInfo, hail: RiskInfo, tornado: RiskInfo) {
        self.wind = wind
        self.hail = hail
        self.tornado = tornado
    }
    
    static var none: CombinedRisks {
        .init(wind: .none, hail: .none, tornado: .none)
    }
}
