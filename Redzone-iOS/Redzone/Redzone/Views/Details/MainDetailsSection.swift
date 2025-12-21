//
//  MainDetailsSection.swift
//  Redzone
//
//  Created by Greg Whatley on 9/30/25.
//

import CoreLocation
import RedzoneCore
import RedzoneUI
import SwiftUI

struct MainDetailsSection: View {
    @Environment(LocationService.self) private var locationService
    
    let outlook: Outlook
    let response: OutlookResponse

    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                switch outlook.highestRisk.properties.severity {
                case .generalThunder:
                    Text(.Convective.tstmHeadline)
                        .fontWeight(.medium)
                    Text(.Convective.tstmCaption)
                case .marginal:
                    Text(.Convective.mrglHeadline)
                        .fontWeight(.medium)
                    Text(.Convective.mrglCaption)
                case .slight:
                    Text(.Convective.slgtHeadline)
                        .fontWeight(.medium)
                    Text(.Convective.slgtCaption)
                case .enhanced:
                    Text(.Convective.enhHeadline)
                        .fontWeight(.medium)
                    Text(.Convective.enhCaption)
                case .moderate:
                    Text(.Convective.mdtHeadline)
                        .fontWeight(.medium)
                    Text(.Convective.mdtCaption)
                case .high:
                    Text(.Convective.highHeadline)
                        .fontWeight(.medium)
                    Text(.Convective.highCaption)
                case let .percentage(pct):
                    let label: LocalizedStringResource = {
                        switch outlook.outlookType {
                        case .convective(.day1(.wind)), .convective(.day2(.wind)): .Education.severeTstormWind
                        case .convective(.day1(.hail)), .convective(.day2(.hail)): .Education.severeTstormHail
                        case .convective(.day1(.tornado)), .convective(.day2(.tornado)): .Education.severeTstormTornado
                        default: .Convective.anySevereWeatherLabel
                        }
                    }()
                    Text(.Convective.percentageCaption(percentage: Int(pct * 100), label: String(localized: label)))
                default:
                    EmptyView()
                }
            }
            .geometryGroup()
            OutlookLocationStatusLabel(feature: outlook.highestRisk, location: locationService.lastKnownLocation?.coordinate, response: response)
        } header: {
            Label {
                Text(outlook.highestRisk.properties.title)
                    .font(.body.weight(.medium))
                    .foregroundStyle(Color(uiColor: .label))
            } icon: {
                switch outlook.outlookType {
                case .convective(let convective) where convective.isCategorical:
                    CategoricalGaugeView(properties: outlook.highestRisk.properties, mode: .legend)
                default:
                    OutlookLegendIconView(properties: outlook.highestRisk.properties)
                }
            }
            .labelStyle(.verticallyCentered)
            .geometryGroup()
        }
        .listRowBackground(Color(uiColor: .secondarySystemFill).opacity(0.8))
    }
}
