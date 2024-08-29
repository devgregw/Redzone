//
//  RiskBreakdownWidgetEntryView.swift
//  SPCMapWidgets
//
//  Created by Greg Whatley on 8/18/24.
//

import SwiftUI
import WidgetKit

struct RiskBreakdownWidgetEntryView: WidgetFoundation.EntryView {
    @Environment(\.widgetFamily) var widgetFamily
    
    typealias Provider = OutlookProvider
    typealias ErrorContent = WidgetErrorView
    
    let entry: WidgetFoundation.Entry<Provider.EntryData>
    
    @ViewBuilder func mainContent(data: Provider.EntryData) -> some View {
        switch widgetFamily {
        case .accessoryInline:
            RiskText(risks: data.risks)
        case .accessoryRectangular:
            HorizontalRiskView(risks: data.risks)
        default: EmptyView()
        }
    }
}

extension RiskBreakdownWidgetEntryView {
    struct RiskText: View {
        let risks: CombinedRisks
        
        var body: some View {
            if risks.anyForecast {
                Image(systemName: risks.anySignificant ? "exclamationmark.triangle.fill" : "cloud.bolt.rain")
                Text(risks.description)
            } else {
                Image(systemName: "sparkles")
                Text("No Severe Forecast")
            }
        }
    }

    struct RiskIconView: View {
        let image: String
        let info: CombinedRisks.RiskInfo
        
        var body: some View {
            VStack {
                Image(systemName: image)
                    .font(.title)
                    .symbolVariant(.circle)
                    .symbolRenderingMode(.hierarchical)
                    .overlay(alignment: .bottomTrailing) {
                        if info.isSignificant {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.callout)
                        }
                    }
                Text(info.percentage > .zero ? "\(info.percentage)%" : "--")
                    .font(.callout)
            }
            .opacity(info.percentage > .zero ? 1 : 0.5)
        }
    }

    struct HorizontalRiskView: View {
        let risks: CombinedRisks
        
        var body: some View {
            if risks.anyForecast {
                HStack {
                    RiskIconView(image: "wind", info: risks.wind)
                    Spacer()
                    RiskIconView(image: "cloud.hail", info: risks.hail)
                    Spacer()
                    RiskIconView(image: "tornado", info: risks.tornado)
                }
            } else {
                NoSevereView()
            }
        }
    }
}

#Preview(as: .accessoryInline) {
    RiskBreakdownWidget()
} timeline: {
    OutlookProvider.Entry.preview
    OutlookProvider.Entry.placeholder
    OutlookProvider.Entry.success(.none)
    OutlookProvider.Entry.error(.noLocation)
    OutlookProvider.Entry.error(.unknown)
}

#Preview(as: .accessoryRectangular) {
    RiskBreakdownWidget()
} timeline: {
    OutlookProvider.Entry.preview
    OutlookProvider.Entry.placeholder
    OutlookProvider.Entry.success(.none)
    OutlookProvider.Entry.error(.noLocation)
    OutlookProvider.Entry.error(.unknown)
}
