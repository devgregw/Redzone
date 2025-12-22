//
//  CombinedConvectiveRiskWidgetEntryView.swift
//  Redzone
//
//  Created by Greg Whatley on 12/12/25.
//

import RedzoneCore
import RedzoneUI
import SwiftUI
import WidgetKit

struct CombinedConvectiveRiskWidgetEntryView: View {
    @Environment(\.widgetFamily) private var widgetFamily

    let entry: CombinedConvectiveRiskProvider.Entry

    var body: some View {
        ZStack {
            switch widgetFamily {
            case .systemSmall, .systemMedium:
                systemSizes
            case .accessoryCircular:
                switch entry.result {
                case let .success(data):
                    CategoricalGaugeView(
                        properties: .init(
                            id: data.convective.value,
                            title: data.convective.title,
                            fillColor: "",
                            strokeColor: "",
                            expire: "",
                            valid: "",
                            issue: ""
                        )
                    )
                case let .failure(error):
                    switch error {
                    case .fetchError:
                        AccessoryWidgetBackground()
                        Image(systemName: "xmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title)
                    case .locationDisabled:
                        AccessoryWidgetBackground()
                        Image(systemName: "location.slash.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title)
                    case .noRisk:
                        AccessoryWidgetBackground()
                        Image(systemName: "sparkles")
                            .symbolRenderingMode(.multicolor)
                            .font(.title)
                    case .placeholder:
                        CategoricalGaugeView(
                            properties: .init(
                                id: "TSTM",
                                title: "",
                                fillColor: "",
                                strokeColor: "",
                                expire: "",
                                valid: "",
                                issue: ""
                            )
                        )
                    }
                }
            case .accessoryRectangular:
                switch entry.result {
                case let .success(data):
                    HStack {
                        if let discrete = data.discreteRisks {
                            Spacer()
                            VStack {
                                Spacer()
                                Image(systemName: discrete.wind?.sig == true ? "exclamationmark.triangle.fill" : "wind")
                                Spacer()
                                Group {
                                    if let value = discrete.wind?.value {
                                        Text("\(value)%")
                                    } else {
                                        Text("--")
                                    }
                                }
                                .font(.caption)
                            }
                            .foregroundStyle(discrete.wind == nil ? .secondary : .primary)
                            Spacer()
                            VStack {
                                Spacer()
                                Image(systemName: discrete.hail?.sig == true ? "exclamationmark.triangle.fill" : "cloud.hail")
                                Spacer()
                                Group {
                                    if let value = discrete.hail?.value {
                                        Text("\(value)%")
                                    } else {
                                        Text("--")
                                    }
                                }
                                .font(.caption)
                            }
                            .foregroundStyle(discrete.hail == nil ? .secondary : .primary)
                            Spacer()
                            VStack {
                                Spacer()
                                Image(systemName: discrete.tornado?.sig == true ? "exclamationmark.triangle.fill" : "tornado")
                                Spacer()
                                Group {
                                    if let value = discrete.tornado?.value {
                                        Text("\(value)%")
                                    } else {
                                        Text("--")
                                    }
                                }
                                .font(.caption)
                            }
                            .foregroundStyle(discrete.tornado == nil ? .secondary : .primary)
                            Spacer()
                        }
                    }
                    .padding(.vertical)
                case let .failure(error):
                    switch error {
                    case .fetchError:
                        VStack {
                            Image(systemName: "xmark.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                            Text("Failed to load data")
                                .multilineTextAlignment(.center)
                                .font(.caption.weight(.medium))
                        }
                    case .locationDisabled:
                        VStack {
                            Image(systemName: "location.slash.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                            Text("Location services disabled")
                                .multilineTextAlignment(.center)
                                .font(.caption.weight(.medium))
                        }
                    case .noRisk:
                        VStack {
                            Image(systemName: "sparkles")
                                .symbolRenderingMode(.multicolor)
                            Text("No severe forecast")
                                .multilineTextAlignment(.center)
                                .font(.caption.weight(.medium))
                        }
                    case .placeholder:
                        HStack {
                                Spacer()
                                VStack {
                                    Spacer()
                                    Image(systemName: "wind")
                                    Spacer()
                                    Text("99%")
                                        .font(.caption)
                                }
                                Spacer()
                                VStack {
                                    Spacer()
                                    Image(systemName: "cloud.hail")
                                    Spacer()
                                    Text("99%")
                                        .font(.caption)
                                }
                                Spacer()
                                VStack {
                                    Spacer()
                                    Image(systemName: "tornado")
                                    Spacer()
                                    Text("99%")
                                        .font(.caption)
                                }
                                Spacer()
                            }
                        .padding(.vertical)
                    }
                }
            case .accessoryInline: Image(systemName: "xmark")
            default: Image(systemName: "xmark")
            }
        }
        .redacted(reason: entry.result == .failure(.placeholder) ? .placeholder : [])
        .containerBackground(.background, for: .widget)
        .widgetURL(URL(string: "redzone://map/\(entry.day.categoricalType.rawValue.joined(separator: "/"))"))
    }
}

extension CombinedConvectiveRiskWidgetEntryView {
    var systemSizes: some View {
        VStack {
            switch entry.result {
            case .success(let success):
                HStack {
                    VStack {
                        CategoricalGaugeView(
                            properties: .init(
                                id: success.convective.value,
                                title: success.convective.title,
                                fillColor: "",
                                strokeColor: "",
                                expire: "",
                                valid: "",
                                issue: ""
                            )
                        )
                        Text(success.convective.title)
                            .font(.subheadline.weight(.medium))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    if entry.day.supportsOutlookBreakdown,
                       widgetFamily == .systemMedium,
                       let discreteRisks = success.discreteRisks {
                        Divider()
                            .frame(width: 1)
                            .padding(.vertical, 8)
                        VStack(alignment: .leading, spacing: 12) {
                            RiskLabel(
                                value: discreteRisks.wind?.value,
                                sig: discreteRisks.wind?.sig ?? false,
                                name: "Wind Risk",
                                image: "wind"
                            )
                            RiskLabel(
                                value: discreteRisks.hail?.value,
                                sig: discreteRisks.hail?.sig ?? false,
                                name: "Hail Risk",
                                image: "cloud.hail"
                            )
                            RiskLabel(
                                value: discreteRisks.tornado?.value,
                                sig: discreteRisks.tornado?.sig ?? false,
                                name: "Tornado Risk",
                                image: "tornado"
                            )
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .failure(let failure):
                switch failure {
                case .placeholder:
                    CategoricalGaugeView(properties: .init(id: "TSTM", title: "", fillColor: "", strokeColor: "", expire: "", valid: "", issue: ""))
                    Text("Loading...")
                        .multilineTextAlignment(.center)
                        .font(.subheadline.weight(.medium))
                case .noRisk:
                    Image(systemName: "sparkles")
                        .symbolRenderingMode(.multicolor)
                        .font(.title)
                    Text("No severe weather forecast")
                        .multilineTextAlignment(.center)
                        .font(.subheadline.weight(.medium))
                case .locationDisabled:
                    Image(systemName: "location.slash.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.title)
                    Text("Location services disabled")
                        .multilineTextAlignment(.center)
                        .font(.subheadline.weight(.medium))
                case .fetchError:
                    Image(systemName: "xmark.circle.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.title)
                    Text("Failed to load data")
                        .multilineTextAlignment(.center)
                        .font(.subheadline.weight(.medium))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .bottom, alignment: .center) {
            Text("\(entry.date, format: .dateTime.hour().minute()) • Day \(entry.day.rawValue)")
            .font(.caption)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
        }
    }
}

struct RiskLabel: View {
    let value: Int?
    let sig: Bool
    let name: String
    let image: String

    var body: some View {
        Label {
            if let value {
                Text("\(value)% \(name)")
            } else {
                Text("No \(name)")
            }
        } icon: {
            Image(systemName: sig ? "exclamationmark.triangle.fill" : image)
                .symbolRenderingMode(sig ? .multicolor : .monochrome)
        }
        .foregroundStyle(value == nil ? .secondary : .primary)
        .font(.footnote)
    }
}

#Preview("systemSmall", as: .systemSmall) {
    CombinedConvectiveRiskWidget()
} timeline: {
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .success(.placeholder))
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .failure(.noRisk))
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .failure(.locationDisabled))
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .failure(.fetchError))
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .failure(.placeholder))
}

#Preview("systemMedium", as: .systemMedium) {
    CombinedConvectiveRiskWidget()
} timeline: {
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .success(.placeholder))
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .failure(.noRisk))
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .failure(.locationDisabled))
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .failure(.fetchError))
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .failure(.placeholder))
}

#Preview("accessoryCircular", as: .accessoryCircular) {
    CombinedConvectiveRiskWidget()
} timeline: {
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .success(.placeholder))
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .failure(.noRisk))
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .failure(.locationDisabled))
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .failure(.fetchError))
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .failure(.placeholder))
}

#Preview("accessoryRectangular", as: .accessoryRectangular) {
    CombinedConvectiveRiskWidget()
} timeline: {
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .success(.placeholder))
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .failure(.noRisk))
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .failure(.locationDisabled))
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .failure(.fetchError))
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .failure(.placeholder))
}

#Preview("accessoryInline", as: .accessoryInline) {
    CombinedConvectiveRiskWidget()
} timeline: {
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .success(.placeholder))
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .failure(.noRisk))
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .failure(.locationDisabled))
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .failure(.fetchError))
    CombinedConvectiveRiskProvider.Entry(day: .dayOne, result: .failure(.placeholder))
}
