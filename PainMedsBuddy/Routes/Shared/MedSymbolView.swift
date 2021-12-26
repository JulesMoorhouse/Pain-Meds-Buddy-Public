//
//  MedSymbolView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct MedSymbolView: View {
    @ObservedObject var med: Med
    let font: Font
    let width: CGFloat
    let height: CGFloat

    init(med: Med, font: Font = .title, width: CGFloat = 45, height: CGFloat = 45) {
        self.med = med
        self.font = font
        self.width = width
        self.height = height
    }

    var body: some View {
        Image(systemName: med.medSymbol)
            .font(font)
            .foregroundColor(Color(med.medColor))
            .frame(width: width, height: height)
    }
}

struct MedSymbolView_Previews: PreviewProvider {
    static var previews: some View {
        MedSymbolView(med: Med())
    }
}
