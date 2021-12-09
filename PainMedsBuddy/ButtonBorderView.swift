//
//  ButtonBorderView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct ButtonBorderView: View {
    let text: String
    let width: CGFloat
    
    init(text: String, width: CGFloat) {
        self.text = text
        self.width = width
    }

    init(text: String) {
        self.init(text: text, width: 150)
    }
    
    var body: some View {
        Text(text)
            .padding(10)
            .frame(width: width)
            .overlay(
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(lineWidth: 2.0)
            )
    }
}

struct ButtonBorderView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonBorderView(text: "Hello", width: 150)
    }
}
