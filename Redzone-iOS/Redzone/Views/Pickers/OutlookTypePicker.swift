//
//  OutlookTypePicker.swift
//  Redzone
//
//  Created by Greg Whatley on 4/8/23.
//

import SwiftUI

struct OutlookTypePicker: View {
    @CodedAppStorage(AppStorageKeys.outlookType) private var outlookType: OutlookType = Context.defaultOutlookType
    
    private func button(_ outlook: OutlookType) -> some View {
        Button {
            outlookType = outlook
        } label: {
            if outlookType == outlook {
                Label("Day \(outlook.day)", systemImage: "checkmark")
            } else {
                Text("Day \(outlook.day)")
            }
        }
    }
    
    private func checkmark(when condition: Bool, _ fallback: String) -> String {
        condition ? "checkmark" : fallback
    }
    
    private func submenu(_ convectiveType: OutlookType.ConvectiveOutlookType) -> some View {
        Menu {
            button(.convective1(convectiveType))
            button(.convective2(convectiveType))
            if convectiveType == .categorical {
                button(.convective3(probabilistic: false))
            }
        } label: {
            switch outlookType {
            case let .convective1(subtype), let .convective2(subtype):
                Label(convectiveType.displayName, systemImage: checkmark(when: subtype == convectiveType, convectiveType.systemImage))
            case .convective3(probabilistic: false):
                Label(convectiveType.displayName, systemImage: checkmark(when: convectiveType == .categorical, convectiveType.systemImage))
            default: Text(convectiveType.displayName)
            }
        }
    }
    
    var body: some View {
        Menu {
            Menu {
                submenu(.categorical)
                submenu(.wind)
                submenu(.hail)
                submenu(.tornado)
                
                Menu {
                    button(.convective3(probabilistic: true))
                    button(.convective4)
                    button(.convective5)
                    button(.convective6)
                    button(.convective7)
                    button(.convective8)
                } label: {
                    Label("Probabilistic", systemImage: checkmark(when: outlookType.isProbabilistic, "percent"))
                }
            } label: {
                Label("Convective", systemImage: checkmark(when: outlookType.isConvective, "cloud.bolt.rain.fill"))
            }
        } label: {
            Label("Outlook Type", systemImage: "binoculars")
        }
        .menuOrder(.fixed)
    }
}
