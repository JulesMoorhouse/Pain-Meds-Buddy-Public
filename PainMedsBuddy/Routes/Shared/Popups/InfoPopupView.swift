//
//  InfoPopupView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct InfoPopupView: View {
    @Binding var showing: Bool
    let text: LocalizedStringKey

    var body: some View {
        PopUpView(text: "INFO", content: {
            Text(text)
                .font(.footnote)
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
        bottomButton: {})
    }
}

struct InfoPopupView_Previews: PreviewProvider {
    static var previews: some View {
        InfoPopupView(
            showing: .constant(true),
            text: "Some help information which will try to span over multiple lines")
    }
}
