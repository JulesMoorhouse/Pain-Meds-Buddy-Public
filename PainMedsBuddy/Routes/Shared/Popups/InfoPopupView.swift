//
//  InfoPopupView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct InfoPopupView: View {
    @Binding var showing: Bool
    let title: LocalizedStringKey
    let text: LocalizedStringKey

    var body: some View {
        PopUpView(text: title,
                  content: {
                      Text(text)
                          .font(.footnote)
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
                  bottomButton: {})
    }
}

struct InfoPopupView_Previews: PreviewProvider {
    static var previews: some View {
        InfoPopupView(
            showing: .constant(true),
            title: "Info",
            text: "Some help information which will try to span over multiple lines"
        )
    }
}
