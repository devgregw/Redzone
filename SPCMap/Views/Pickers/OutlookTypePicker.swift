//
//  OutlookTypePicker.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/8/23.
//

import SwiftUI

struct OutlookTypePicker: View {
    @Environment(Context.self) private var context
    
    private func button(_ outlook: OutlookType) -> some View {
        @Bindable var context = context
        return Button {
            context.outlookType = outlook
        } label: {
            if context.outlookType == outlook {
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
            switch context.outlookType {
            case let .convective1(subtype), let .convective2(subtype):
                Label(convectiveType.displayName, systemImage: checkmark(when: subtype == convectiveType, convectiveType.systemImage))
            case .convective3(probabilistic: false):
                Label(convectiveType.displayName, systemImage: checkmark(when: convectiveType == .categorical, convectiveType.systemImage))
            default: Text(convectiveType.displayName)
            }
        }
    }
    
    var body: some View {
        HStack {
            Label("Outlook", systemImage: "binoculars")
            Spacer()
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
                        Label("Probabilistic", systemImage: checkmark(when: context.outlookType.isProbabilistic, "percent"))
                    }
                } label: {
                    Label("Convective", systemImage: checkmark(when: context.outlookType.isConvective, "cloud.bolt.rain.fill"))
                }
            } label: {
                HStack {
                    VStack(alignment: .trailing) {
                        Text("\(context.outlookType.subSection) • Day \(context.outlookType.day)")
                        Text(context.outlookType.category)
                            .font(.footnote)
                    }
                    Image(systemName: "chevron.up.chevron.down")
                        .imageScale(.small)
                }
            }
            .menuOrder(.fixed)
        }
    }
}
