//
//  TimeEditPicker.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct TimeEditPicker: View {
    @Binding var duration: String
    let hourAid: Strings
    let minuteAid: Strings

    var body: some View {
        GeometryReader { _ in
            HStack(spacing: 0) {
                Spacer()
                HourMinutePicker(duration: $duration,
                                 hourAid: hourAid,
                                 minuteAid: minuteAid)
                Spacer()
            }
        }
        .frame(height: 160)
        .mask(Rectangle())
        .border(Color.secondary.opacity(0.2))
    }
}

struct TimeEditPicker_Previews: PreviewProvider {
    static var previews: some View {
        TimeEditPicker(duration: .constant("60"),
                       hourAid: .nothing,
                       minuteAid: .nothing)
    }
}
