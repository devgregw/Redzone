//
//  SPCMapWidget.swift
//  SPCMapWidget
//
//  Created by Greg Whatley on 4/5/24.
//

import CoreLocation
import WidgetKit
import SwiftUI
import MapKit

struct Provider: TimelineProvider {
    typealias Entry = OutlookEntry
    
    func placeholder(in context: Context) -> Entry {
        .placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        completion(.snapshot)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            switch await OutlookFetcher.fetch(outlook: .convective1(.categorical)) {
            case .success(let response):
                await MainActor.run {
                    WidgetLocation.shared.requestOneTimeLocation {
                        guard let location = $0 else {
                            completion(.init(entries: [.error(.noLocation)], policy: .after(.now.addingTimeInterval(60 * 60 * 2))))
                            return
                        }
                        let outlook = response.features
                            .filterNot(by: \.outlookProperties.isSignificant)
                            .sorted()
                            .reversed()
                            .first {
                                $0.geometry.lazy.compactCast(to: MKMultiPolygon.self).contains { $0.contains(point: .init(location.coordinate)) }
                            }
                        completion(.init(entries: [.outlook(.now, outlook)], policy: .after(.now.addingTimeInterval(60 * 60 * 2))))
                    }
                }
            default:
                completion(.init(entries: [.error(.unknown)], policy: .after(.now.addingTimeInterval(60 * 60 * 2))))
            }
        }
    }
}

enum OutlookEntry: TimelineEntry {
    enum EntryError: Error {
        case noLocation
        case unknown
    }
    case outlook(Date, OutlookFeature?)
    case placeholder
    case error(EntryError)
    case snapshot
    
    var date: Date {
        return if case .outlook(let date, _) = self {
            date
        } else {
            .init(timeIntervalSinceNow: -3600)
        }
    }
    
    var showDate: Bool {
        return switch self {
        case .placeholder, .error: false
        default: true
        }
    }
}

struct SPCMapWidgetEntryView : View {
    var entry: Provider.Entry

    var dateString: String {
        entry.date.formatted(date: .numeric, time: .shortened)
    }
    
    @ViewBuilder func gauge(title: String, value: Double) -> some View {
        Gauge(value: value, in: 0...5) {
            Text("Label")
                .font(.body.bold())
                .multilineTextAlignment(.center)
        } currentValueLabel: {
            Image("NOAALogo", bundle: .main)
                .resizable()
                .frame(width: 25, height: 25)
        } minimumValueLabel: {
            Text("GT")
        } maximumValueLabel: {
            Text("HI")
        }
        .gaugeStyle(.accessoryCircular)
        .tint(Gradient(colors: [.green.opacity(0.5), .green, .yellow, .orange, .red, .magenta]))
        Text(title)
            .multilineTextAlignment(.center)
            .font(.callout.weight(.medium))
            .minimumScaleFactor(0.5)
    }
    
    @ViewBuilder var noLocationErrorView: some View {
        Image(systemName: "location.circle.fill")
            .symbolRenderingMode(.hierarchical)
            .font(.largeTitle)
            .overlay(alignment: .bottomTrailing) {
                Image(systemName: "exclamationmark.circle.fill")
                    .background(.background)
                    .clipShape(Circle())
                    .symbolRenderingMode(.multicolor)
            }
        Text("Location services unavailable")
            .multilineTextAlignment(.center)
            .font(.footnote)
            .minimumScaleFactor(0.5)
    }
    
    @ViewBuilder var unknownErrorView: some View {
        Image("NOAALogo", bundle: .main)
            .resizable()
            .frame(width: 40, height: 40)
            .overlay(alignment: .bottomTrailing) {
                Image(systemName: "exclamationmark.circle.fill")
                    .background(.background)
                    .clipShape(Circle())
                    .symbolRenderingMode(.multicolor)
            }
        Text("Unknown error")
            .multilineTextAlignment(.center)
            .font(.footnote)
            .minimumScaleFactor(0.5)
    }
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 1) {
                switch entry {
                case .outlook(_, let feature):
                    if let feature {
                        gauge(title: feature.outlookProperties.title, value: feature.outlookProperties.severity.comparableValue)
                    } else {
                        Image(systemName: "sparkles")
                            .symbolRenderingMode(.multicolor)
                            .font(.largeTitle)
                        Text("No severe weather forecast")
                            .multilineTextAlignment(.center)
                            .font(.footnote)
                            .minimumScaleFactor(0.5)
                    }
                case .snapshot:
                    gauge(title: "Enhanced Risk", value: 3)
                case .placeholder:
                    Circle()
                        .fill(.secondary.quaternary)
                        .frame(width: 50, height: 50)
                    Text("Placeholder")
                        .multilineTextAlignment(.center)
                        .font(.callout.weight(.medium))
                        .minimumScaleFactor(0.5)
                        .redacted(reason: .placeholder)
                case .error(let type):
                    switch type {
                    case .noLocation: noLocationErrorView
                    case .unknown: unknownErrorView
                    }
                }
            }
            Spacer()
            HStack(spacing: 2) {
                if entry.showDate {
                    Image(systemName: "clock")
                    Text(dateString)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                } else {
                    Text("Placeholder")
                        .redacted(reason: .placeholder)
                }
            }
            .foregroundStyle(.secondary)
            .font(.caption2)
        }
    }
}

struct SPCMapWidget: Widget {
    let kind: String = "SPCMapWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                SPCMapWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                SPCMapWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Current Location Outlook")
        .description("Displays the latest day 1 convective outlook at your current location.")
    }
}

#Preview(as: .systemSmall) {
    SPCMapWidget()
} timeline: {
    OutlookEntry.snapshot
    OutlookEntry.placeholder
    OutlookEntry.outlook(.now, nil)
    OutlookEntry.error(.noLocation)
    OutlookEntry.error(.unknown)
}
