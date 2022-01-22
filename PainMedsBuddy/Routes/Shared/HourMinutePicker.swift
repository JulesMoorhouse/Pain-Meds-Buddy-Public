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

    let hourAid: Strings
    let minuteAid: Strings

    var body: some View {
        if #available(iOS 15, *) {
            HStack {
                TimePicker(
                    hours: true,
                    selected: self.$selectedHour.onChange(update),
                    aId: hourAid
                )

                TimePicker(
                    hours: false,
                    selected: self.$selectedMinute.onChange(update),
                    aId: minuteAid
                )
            }
        } else {
            TimePicker(
                hours: true,
                selected: self.$selectedHour.onChange(update),
                aId: hourAid
            )
            .labelsHidden()
            .fixedSize(horizontal: true, vertical: true)
            .frame(width: 65, height: 160)
            .clipped()
            .background(Color(UIColor.systemBackground))

            TimePicker(
                hours: false,
                selected: self.$selectedMinute.onChange(update),
                aId: minuteAid
            )
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

    init(duration: Binding<String>, hourAid: Strings, minuteAid: Strings) {
        let hours = (Int(duration.wrappedValue) ?? 0) / 3600
        let minutes = (Int(duration.wrappedValue) ?? 0) / 60 % 60

        selectedHour = hours
        selectedMinute = minutes
        _duration = duration
        self.hourAid = hourAid
        self.minuteAid = minuteAid
    }
}

struct HourMinutePicker_Previews: PreviewProvider {
    static var previews: some View {
        HourMinutePicker(duration: .constant("60"),
                         hourAid: .nothing,
                         minuteAid: .nothing)
    }
}
