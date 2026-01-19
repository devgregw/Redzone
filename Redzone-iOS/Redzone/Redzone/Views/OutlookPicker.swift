//
//  OutlookPicker.swift
//  Redzone
//
//  Created by Greg Whatley on 9/27/25.
//

import RedzoneCore
import RedzoneUI
import SwiftUI

struct OutlookPicker: View {
    private struct Submenu<Content: View>: View {
        let title: LocalizedStringResource
        let systemImage: String
        let isSelected: Bool
        @ViewBuilder let content: Content

        var body: some View {
            Menu {
                content
            } label: {
                Label(title, systemImage: isSelected ? "checkmark" : systemImage)
            }
        }
    }

    @Binding var selection: OutlookType

    var body: some View {
        Menu {
            ControlGroupPicker(.Convective.categorical, selection: $selection) {
                Label("Day 1", systemImage: "square.3.layers.3d.top.filled")
                    .tag(OutlookType.convective(.day1(.categorical)))
                Label("Day 2", systemImage: "square.3.layers.3d.middle.filled")
                    .tag(OutlookType.convective(.day2(.categorical)))
                Label("Day 3", systemImage: "square.3.layers.3d.bottom.filled")
                    .tag(OutlookType.convective(.day3(probabilistic: false)))
            }

            Section("Discrete") {
                Submenu(
                    title: .Convective.wind,
                    systemImage: "wind",
                    isSelected: selection.description.contains("Wind")
                ) {
                    SelectionButton(selection: $selection, value: .convective(.day1(.wind)), label: "Day 1")
                    SelectionButton(selection: $selection, value: .convective(.day2(.wind)), label: "Day 2")
                }
                Submenu(
                    title: .Convective.hail,
                    systemImage: "cloud.hail",
                    isSelected: selection.description.contains("Hail")
                ) {
                    SelectionButton(selection: $selection, value: .convective(.day1(.hail)), label: "Day 1")
                    SelectionButton(selection: $selection, value: .convective(.day2(.hail)), label: "Day 2")
                }
                Submenu(
                    title: .Convective.tornado,
                    systemImage: "tornado",
                    isSelected: selection.description.contains("Tornado")
                ) {
                    SelectionButton(selection: $selection, value: .convective(.day1(.tornado)), label: "Day 1")
                    SelectionButton(selection: $selection, value: .convective(.day2(.tornado)), label: "Day 2")
                }
            }
            Section {
                Submenu(
                    title: .Convective.probabilistic,
                    systemImage: "percent",
                    isSelected: selection.description.contains("Probabilistic")
                ) {
                    SelectionButton(selection: $selection, value: .convective(.day3(probabilistic: true)), label: "Day 3")
                    SelectionButton(selection: $selection, value: .convective(.day4), label: "Day 4")
                    SelectionButton(selection: $selection, value: .convective(.day5), label: "Day 5")
                    SelectionButton(selection: $selection, value: .convective(.day6), label: "Day 6")
                    SelectionButton(selection: $selection, value: .convective(.day7), label: "Day 7")
                    SelectionButton(selection: $selection, value: .convective(.day8), label: "Day 8")
                }
            }
        } label: {
            Label("Outlook", systemImage: "binoculars")
            Text(selection.description)
        }
    }
}
