//
//  SigSevDetailsSection.swift
//  Redzone
//
//  Created by Greg Whatley on 9/30/25.
//

import CoreLocation
import RedzoneCore
import RedzoneUI
import SwiftUI

struct SigSevDetailsSection: View {
    @Environment(LocationService.self) private var locationService
    
    let feature: OutlookResponse.Feature
    let outlookType: OutlookType

    var body: some View {
        Section {
            switch outlookType {
            case .convective(.day1(.wind)), .convective(.day2(.wind)):
                Text(.Convective.percentageCaption(percentage: 10, label: String(localized: .Education.sigSevTstormWind)))
            case .convective(.day1(.hail)), .convective(.day2(.hail)):
                Text(.Convective.percentageCaption(percentage: 10, label: String(localized: .Education.sigSevTstormHail)))
            case .convective(.day1(.tornado)), .convective(.day2(.tornado)):
                Text(.Convective.percentageCaption(percentage: 10, label: String(localized: .Education.sigSevTstormTornado)))
            default:
                Text(.Convective.percentageCaption(percentage: 10, label: String(localized: .Convective.anySigSevWeatherLabel)))
            }
            OutlookLocationStatusLabel(feature: feature, location: locationService.lastKnownLocation?.coordinate)
        } header: {
            Label {
                Text(feature.properties.title)
                    .font(.body.weight(.medium))
                    .foregroundStyle(Color(uiColor: .label))
            } icon: {
                SigSevLegendIconView()
            }
        }
        .listRowBackground(Color(uiColor: .secondarySystemFill).opacity(0.8))
        .geometryGroup()
    }
}
