//
//  OutlookColor.swift
//  SPC
//
//  Created by Greg Whatley on 4/23/23.
//

import SwiftUI
import SPCCommon

extension OutlookColor {
    var strokeColor: Color {
        .init(hex: stroke)
    }
    
    var fillColor: Color {
        .init(hex: fill)
    }
}
