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

    var body: some View {
        PopUpView(
            text: title,
            width: 300,
            content: {
                DurationPicker(duration: $duration)
            },
            leftButton: {},
            rightButton: {
                Button(action: {
                    showing = false
                }, label: {
                    Image(systemName: SFSymbol.xMark.systemName)
                        .font(.headline)
                })
            },
            bottomButton: {
                Button(action: {
                    showing = false
                }, label: {
                    Text(.commonOK)
                })
            })
    }
}

struct DurationPopupView_Previews: PreviewProvider {
    static var previews: some View {
        DurationPopupView(
            title: "DURATION",
            showing: .constant(true),
            duration: .constant("240"))
    }
}
