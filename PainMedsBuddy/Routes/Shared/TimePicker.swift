//
//  TimePicker.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct TimePicker: View {
    let hours: Bool

    var min: [Int] = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55]

    @Binding var selected: Int

    let aId: Strings

    var body: some View {
        if #available(iOS 15, *) {
            Picker("", selection: self.$selected) {
                contents(hours: hours)
            }
            .pickerStyle(.menu)
            .accessibility(identifier: aId.automatedId())
        } else {
            Picker("", selection: self.$selected) {
                contents(hours: hours)
            }
            .accessibility(identifier: aId.automatedId())
        }
    }

    // NOTE: in iOS 15.2 there is a bug in the simulator
    // where the menu items on their second use appear in
    // the wrong order, this doesn't occur on an actual
    // device
    func contents(hours: Bool) -> some View {
        Group {
            if hours {
                ForEach(0 ..< 13) {
                    let label = String(.timePickerHours, values: ["\($0)"])
                    Text(label)
                        .tag($0)
                        .font(.callout)
                }
            } else {
                ForEach(self.min, id: \.self) {
                    let label = String(.timePickerMins, values: ["\($0)"])
                    Text(label)
                        .tag($0)
                        .font(.callout)
                }
            }
        }
    }
}

struct TimePicker_Previews: PreviewProvider {
    static var previews: some View {
        TimePicker(hours: true, selected: .constant(5), aId: .commonInfo)
    }
}
