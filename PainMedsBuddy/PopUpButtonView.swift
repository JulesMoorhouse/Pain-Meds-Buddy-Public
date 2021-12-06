//
//  PopUpButtonView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct PopUpButtonView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .padding(10)
            .frame(width: 150)
            .overlay(
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(lineWidth: 2.0)
            )
    }
}

struct PopUpButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PopUpButtonView(text: "Hello")
    }
}
