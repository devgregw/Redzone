//
//  OutlookTimestampSection.swift
//  Redzone
//
//  Created by Greg Whatley on 10/2/25.
//

import SwiftUI

struct OutlookTimestampSection: View {
    let issue: Date
    let expire: Date

    var body: some View {
        Section {
            VStack(spacing: 8) {
                VStack(alignment: .trailing) {
                    HStack(alignment: .top) {
                        Text("Iss.")
                        Spacer()
                        Text(issue, format: .dateTime)
                    }

                    Text("(\(issue, style: .relative) ago)")
                }

                VStack(alignment: .trailing) {
                    HStack(alignment: .top) {
                        Text("Exp.")
                        Spacer()
                        Text(expire, format: .dateTime)
                    }

                    if expire >= .now {
                        Text("(in \(expire, style: .relative))")
                    } else {
                        Text("(\(expire, style: .relative) ago)")
                    }
                }
            }
        }
        .listRowBackground(Color.clear)
        .font(.footnote)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.trailing)
        .geometryGroup()
    }
}
