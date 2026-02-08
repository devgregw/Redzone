//
//  AboutRiskLevelsView.swift
//  Redzone
//
//  Created by Greg Whatley on 11/26/25.
//

import RedzoneUI
import SwiftUI

struct AboutRiskLevelsView: View {
    var body: some View {
        List {
            ForEach(Self.risks, id: \.self) {
                $0
            }
        }
        .navigationTitle("Categorical")
        .navigationBarTitleDisplayMode(.inline)
    }
}
