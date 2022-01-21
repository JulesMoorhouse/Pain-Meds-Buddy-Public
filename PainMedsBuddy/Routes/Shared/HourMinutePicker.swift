//
//  HourMinutePicker.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct HourMinutePicker: View {
    @State private var selectedHour: Int = 0
    @State private var selectedMinute: Int = 0

    @Binding var duration: String

    var body: some View {
        if #available(iOS 15, *) {
            HStack {
                TimePicker(
                    hours: true,
                    selected: self.$selectedHour.onChange(update))

                TimePicker(
                    hours: false,
                    selected: self.$selectedMinute.onChange(update))
            }
        } else {
            TimePicker(
                hours: true,
                selected: self.$selectedHour.onChange(update))
                .labelsHidden()
                .fixedSize(horizontal: true, vertical: true)
                .frame(width: 65, height: 160)
                .clipped()
                .background(Color(UIColor.systemBackground))

            TimePicker(
                hours: false,
                selected: self.$selectedMinute.onChange(update))
                .labelsHidden()
                .fixedSize(horizontal: true, vertical: true)
                .frame(width: 65, height: 160)
                .clipped()
                .background(Color(UIColor.systemBackground))
        }
    }

    func update() {
        duration = getDuration()
    }

    func getDuration() -> String {
        let hours = selectedHour < 10 ? "0\(selectedHour)" : "\(selectedHour)"
        let minutes = selectedMinute < 10 ? "0\(selectedMinute)" : "\(selectedMinute)"
        let seconds = "\(hours):\(minutes):00".timeToSeconds
        return "\(seconds)"
    }

    init(duration: Binding<String>) {
        let hours = (Int(duration.wrappedValue) ?? 0) / 3600
        let minutes = (Int(duration.wrappedValue) ?? 0) / 60 % 60

        selectedHour = hours
        selectedMinute = minutes
        _duration = duration
    }
}

struct HourMinutePicker_Previews: PreviewProvider {
    static var previews: some View {
        HourMinutePicker(duration: .constant("60"))
    }
}
