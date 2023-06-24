//
//  OutlookSeverity.swift
//  SPC
//
//  Created by Greg Whatley on 6/13/23.
//

import SPCCommon

extension OutlookSeverity {
    var localizedName: String {
        switch self {
        case .generalThunder: String(localized: "categorical0_name")
        case .marginal: String(localized: "categorical1_name")
        case .slight: String(localized: "categorical2_name")
        case .enhanced: String(localized: "categorical3_name")
        case .moderate: String(localized: "categorical4_name")
        case .high: String(localized: "categorical5_name")
        case .significant: "Significant"
        case .probabilistic: "Probabilistic"
        case .sigprobabilistic: "Sig. Probabilistic"
        }
    }
}
