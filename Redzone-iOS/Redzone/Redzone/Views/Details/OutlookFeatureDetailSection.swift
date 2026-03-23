//
//  OutlookFeatureDetailSection.swift
//  Redzone
//
//  Created by Greg Whatley on 9/30/25.
//

import CoreLocation
import RedzoneCore
import RedzoneUI
import SwiftUI

struct OutlookFeatureDetailSection: View {
    @Environment(LocationService.self) private var locationService

    let collection: OutlookCollection
    let feature: OutlookFeature
    let outlookType: OutlookType

    init(_ feature: OutlookFeature, in collection: OutlookCollection, outlookType: OutlookType) {
        self.collection = collection
        self.feature = feature
        self.outlookType = outlookType
    }

    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                switch feature.properties.severity {
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
                case .fireWindRHElevated:
                    Text(.fireElevatedDesc)
                        .fontWeight(.medium)
                case .fireWindRHCritical:
                    Text(.fireCriticalDesc)
                        .fontWeight(.medium)
                case .fireWindRHExtreme:
                    Text(.fireExtmCriticalDesc)
                        .fontWeight(.medium)
                case .fireIsolatedDryT:
                    Text(.fireIsoDryTDesc)
                        .fontWeight(.medium)
                case .fireScatteredDryT:
                    Text(.fireSctDryTDesc)
                        .fontWeight(.medium)
                case .cig1 where outlookType.convectiveClassification == .tornado:
                    Text(.tornadoCig1)
                case .cig2 where outlookType.convectiveClassification == .tornado:
                    Text(.tornadoCig2)
                case .cig3 where outlookType.convectiveClassification == .tornado:
                    Text(.tornadoCig3)
                case .cig1 where outlookType.convectiveClassification == .wind:
                    Text(.windCig1)
                case .cig2 where outlookType.convectiveClassification == .wind:
                    Text(.windCig2)
                case .cig3 where outlookType.convectiveClassification == .wind:
                    Text(.windCig3)
                case .cig1 where outlookType.convectiveClassification == .hail:
                    Text(.hailCig1)
                case .cig2 where outlookType.convectiveClassification == .hail:
                    Text(.hailCig2)
                case .cig1 where outlookType == .convective(.day3(probabilistic: true)):
                    Text(.cat3Cig1)
                case .cig2 where outlookType == .convective(.day3(probabilistic: true)):
                    Text(.cat3Cig2)
                case let .percentage(pct):
                    let label: LocalizedStringResource = {
                        switch outlookType {
                        case .convective(.day1(.wind)), .convective(.day2(.wind)): .Education.severeTstormWind
                        case .convective(.day1(.hail)), .convective(.day2(.hail)): .Education.severeTstormHail
                        case .convective(.day1(.tornado)), .convective(.day2(.tornado)): .Education.severeTstormTornado
                        default: .Convective.anySevereWeatherLabel
                        }
                    }()
                    Text(.Convective.percentageCaption(percentage: Int(pct * 100), label: String(localized: label).lowercased()))
                default:
                    EmptyView()
                }
            }
            .geometryGroup()
            OutlookLocationStatusLabel(feature: feature, location: locationService.lastKnownLocation?.coordinate, response: collection)
        } header: {
            Label {
                Group {
                    if feature.properties.severity.isCIG {
                        Text(feature.properties.title.trimmingPrefix { $0 != "C" })
                    } else {
                        Text(feature.properties.title)
                    }
                }
                .font(.body.weight(.medium))
                .foregroundStyle(Color(uiColor: .label))
            } icon: {
                switch outlookType {
                case .convective(let convective) where convective.isCategorical:
                    CategoricalGaugeView(properties: feature.properties, mode: .legend)
                default:
                    if feature.properties.severity.isCIG {
                        CIGLegendIconView(severity: feature.properties.severity)
                    } else {
                        OutlookLegendIconView(properties: feature.properties)
                    }
                }
            }
            .labelStyle(.verticallyCentered)
            .geometryGroup()
        }
        .listRowBackground(Color(uiColor: .secondarySystemFill).opacity(0.8))
    }
}

struct CIGLegendIconView: View {
    let group: Int
    let imageName: String
    let dash: CGFloat

    init?(severity: OutlookSeverity) {
        switch severity {
        case .cig1:
            group = 1
            imageName = "exclamationmark"
        case .cig2:
            group = 2
            imageName = "exclamationmark.2"
        case .cig3:
            group = 3
            imageName = "exclamationmark.3"
        default: return nil
        }
        dash = CGFloat(group) * 2
    }

    var body: some View {
        HStack {
            Circle()
                .stroke(Color(uiColor: .label), style: .init(lineWidth: 1.5, dash: [dash, 2]))
                .frame(width: 18, height: 18)
            Image(systemName: imageName)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.red)
        }
    }
}
