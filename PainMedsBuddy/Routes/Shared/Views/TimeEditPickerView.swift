//
//  TimeEditPickerView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct TimeEditPickerView: View {
    @Binding var duration: String
    let hourAid: Strings
    let minuteAid: Strings

    var body: some View {
        GeometryReader { _ in
            HStack(spacing: 0) {
                Spacer()
                HourMinutePickerView(duration: $duration,
                                 hourAid: hourAid,
                                 minuteAid: minuteAid)
                Spacer()
            }
        }
        .frame(height: 160)
        .mask(Rectangle())
        .border(Color.semiDisabledBackground)
    }
}

struct TimeEditPickerView_Previews: PreviewProvider {
    static var previews: some View {
        TimeEditPickerView(duration: .constant("60"),
                       hourAid: .nothing,
                       minuteAid: .nothing)
    }
}
