//
//  MedSymbolView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct MedSymbolView: View {
    let symbol: String
    let colour: String
    let font: Font
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        Image(systemName: symbol)
            .font(font)
            .foregroundColor(Color(colour))
            .frame(width: width, height: height)
    }
    
    init(symbol: String,
         colour: String,
         font: Font = .title,
         width: CGFloat = 45,
         height: CGFloat = 45)
    {
        self.symbol = symbol
        self.colour = colour
        self.font = font
        self.width = width
        self.height = height
    }
}

struct MedSymbolView_Previews: PreviewProvider {
    static var previews: some View {
        MedSymbolView(symbol: "piils", colour: "red")
    }
}
