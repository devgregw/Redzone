//
//  AboutSevTStormView.swift
//  Redzone
//
//  Created by Greg Whatley on 11/26/25.
//

import SwiftUI

struct AboutSevTStormView: View {
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 16) {
                    Text(.Education.severeTstormHeader)
                    Label(.Education.severeTstormWind, systemImage: "wind")
                    Label(.Education.severeTstormHail, systemImage: "cloud.hail")
                    Label(.Education.severeTstormTornado, systemImage: "tornado")
                }
                VStack(alignment: .leading, spacing: 16) {
                    Text(.Education.sigSevTstormHeader)
                    Label(.Education.sigSevTstormWind, systemImage: "wind")
                    Label(.Education.sigSevTstormHail, systemImage: "cloud.hail")
                    Label(.Education.sigSevTstormTornado, systemImage: "tornado")
                }
            } footer: {
                Text(.Education.severeTstormFootnote)
            }
            .listRowBackground(Color(uiColor: .secondarySystemFill).opacity(0.8))
        }
        .navigationTitle(.Education.severeTstormTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}
