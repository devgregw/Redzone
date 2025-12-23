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
    let response: Result<OutlookResponse, any Error>?
    let selectedOutlook: Outlook?
    let isFromSheet: Bool

    @ViewBuilder private func details(for outlook: Outlook, response: OutlookResponse) -> some View {
        MainDetailsSection(outlook: outlook, response: response)
        if let sigSev = outlook.significantFeature {
            SigSevDetailsSection(feature: sigSev, outlookType: outlook.outlookType)
        }
    }

    var body: some View {
        List {
            if case let .success(response) = response,
               let selectedOutlook {
                details(for: selectedOutlook, response: response)
            } else {
                StatusSection(response: response)
            }

            EducationSection()

            if let selectedOutlook,
               let issue = selectedOutlook.highestRisk.properties.issue,
               let expire = selectedOutlook.highestRisk.properties.expire {
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
