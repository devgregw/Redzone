//
//  OutlookPicker.swift
//  SPC
//
//  Created by Greg Whatley on 4/8/23.
//

import SwiftUI

struct OutlookPicker: View {
    @Binding var selection: OutlookType
    
    private func button(_ outlook: OutlookType) -> some View {
        Button {
            selection = outlook
        } label: {
            if selection == outlook {
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
            button(.convective3(convectiveType))
        } label: {
            switch selection {
            case let .convective1(subtype), let .convective2(subtype), let .convective3(subtype):
                Label(convectiveType.displayName, systemImage: checkmark(when: subtype == convectiveType, convectiveType.systemImage))
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
                        button(.convective4)
                        button(.convective5)
                        button(.convective6)
                        button(.convective7)
                        button(.convective8)
                    } label: {
                        Label("Probabilistic", systemImage: checkmark(when: selection.day >= 4, "percent"))
                    }
                } label: {
                    Label("Convective", systemImage: checkmark(when: selection.isConvective, "cloud.bolt.rain.fill"))
                }
            } label: {
                HStack {
                    VStack(alignment: .trailing) {
                        Text("\(selection.subSection) • Day \(selection.day)")
                        Text(selection.category)
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
