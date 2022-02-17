//
//  DurationPopupView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct DurationPopupView: View {
    @Environment(\.colorScheme) var colorScheme

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
                TimeEditPickerView(
                    duration: $duration,
                    hourAid: hourAid,
                    minuteAid: minuteAid
                )
                .background(colorScheme == .dark
                    ? Color(UIColor.systemBackground)
                    : Color.clear)
            },
            leftButton: {},
            rightButton: {
                Button(action: {
                    showing.toggle()
                }, label: {
                    Image(systemName: SFSymbol.xMark.systemName)
                        .font(.headline)

                })
                .frame(width: 25, height: 25, alignment: .center) // Bug fix

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
            }
        )
    }
}

struct DurationPopupView_Previews: PreviewProvider {
    static var previews: some View {
        DurationPopupView(
            title: "DURATION",
            showing: .constant(true),
            duration: .constant("240"),
            hourAid: .nothing,
            minuteAid: .nothing
        )
    }
}
