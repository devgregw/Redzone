//
//  OutlookDetailsView.swift
//  Redzone
//
//  Created by Greg Whatley on 9/27/25.
//

import CoreLocation
import RedzoneCore
import RedzoneUI
import SwiftUI

struct OutlookDetailsView: View {
    let response: Result<OutlookCollection, any Error>?
    let outlookType: OutlookType
    let selectedOutlook: ResolvedOutlook?
    let isFromSheet: Bool

    @ViewBuilder private func details(for outlook: ResolvedOutlook, outlookType: OutlookType, response: OutlookCollection) -> some View {
        if let convectivePrimary = outlook[.convectivePrimary] {
            OutlookFeatureDetailSection(convectivePrimary, in: response, outlookType: outlookType)
            if let convectiveCIG = outlook[.convectiveCIG] {
                OutlookFeatureDetailSection(convectiveCIG, in: response, outlookType: outlookType)
            }
        } else if let fireWindRH = outlook[.fireWindRH] {
            OutlookFeatureDetailSection(fireWindRH, in: response, outlookType: outlookType)
        }
    }

    var body: some View {
        List {
            if case let .success(response) = response,
               let selectedOutlook {
                details(for: selectedOutlook, outlookType: outlookType, response: response)
            } else {
                StatusSection(response: response)
            }

            EducationSection()

            if let selectedOutlook,
               let issue = selectedOutlook.first?.value.properties.issue,
               let expire = selectedOutlook.first?.value.properties.expire {
                OutlookTimestampSection(issue: issue, expire: expire)
            }
        }
        .contentTransition(.opacity)
        .animation(.spring, value: response == nil)
        .animation(.spring, value: selectedOutlook)
        .scrollContentBackground(.hidden)
        .navigationTitle(.riskDetails, displayMode: .inline, isEnabled: isFromSheet)
    }
}
