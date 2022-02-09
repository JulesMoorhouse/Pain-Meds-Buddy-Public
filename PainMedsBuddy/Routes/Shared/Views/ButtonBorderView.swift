//
//  ButtonBorderView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct ButtonBorderView: View {
    let text: LocalizedStringKey
    let width: CGFloat
    let font: Font
    let padding: CGFloat

    var body: some View {
        Text(text)
            .font(font)
            .padding(padding)
            .frame(width: width)
            .overlay(
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(lineWidth: 2.0)
            )
    }

    init(text: LocalizedStringKey, width: CGFloat = 150, font: Font = .body, padding: CGFloat = 10) {
        self.text = text
        self.width = width
        self.font = font
        self.padding = padding
    }
}

struct ButtonBorderView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonBorderView(text: "Hello", width: 150)
    }
}
