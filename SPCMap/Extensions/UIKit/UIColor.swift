//
//  UIColor.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/8/23.
//

import UIKit
import SwiftUI

extension UIColor {
    convenience init(hex string: String) {
        self.init(Color(hex: string))
    }
}
