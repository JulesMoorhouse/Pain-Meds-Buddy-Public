//
//  DurationPopupView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct DurationPopupView: View {
    let title: LocalizedStringKey
    @Binding var showing: Bool
    @Binding var duration: String

    let hourAid: Strings
    let minuteAid: Strings

    var body: some View {
        PopUpView(
            text: title,
            width: 250,
            content: {
                TimeEditPicker(duration: $duration,
                               hourAid: hourAid,
                               minuteAid: minuteAid)
            },
            leftButton: {},
            rightButton: {
                Button(action: {
                    showing.toggle()
                }, label: {
                    Image(systemName: SFSymbol.xMark.systemName)
                        .font(.headline)
                })
            },
            bottomButton: {
                Button(action: {
                    showing.toggle()
                }, label: {
                    Text(.commonOK)
                        .accessibilityElement()
                        .accessibility(addTraits: .isButton)
                        .accessibilityIdentifier(.commonOK)
                })
            })
    }
}

struct DurationPopupView_Previews: PreviewProvider {
    static var previews: some View {
        DurationPopupView(
            title: "DURATION",
            showing: .constant(true),
            duration: .constant("240"),
            hourAid: .nothing,
            minuteAid: .nothing)
    }
}
