//
//  SymbolsView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct SymbolsView: View {
    let colour: Color
    let size: CGFloat = 70

    @Binding var selectedSymbol: String

    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: size, maximum: size))]
    }

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(Symbol.allSymbols) { symbol in
                ZStack {
                    Image(systemName: symbol.name)
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(width: size, height: size)
                        .foregroundColor(colour)

                    if symbol.id == selectedSymbol {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 2)
                            .foregroundColor(Color.black)
                    }
                }
                .onTapGesture {
                    selectedSymbol = symbol.id
                }
            }
        }
    }

    init(colour: Color, selectedSymbol: Binding<String>) {
        self.colour = colour
        _selectedSymbol = selectedSymbol
    }
}

struct SymbolsView_Previews: PreviewProvider {
    static var previews: some View {
        SymbolsView(colour: Color.red, selectedSymbol: .constant("pills"))
    }
}
