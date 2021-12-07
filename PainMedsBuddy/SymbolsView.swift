//
//  SymbolsView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct SymbolsView: View {
    
    let size: CGFloat = 70
    
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: size, maximum: size))]
    }
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(Symbol.allSymbols) { symbol in
                Button {
                    //
                } label: {
                    Image(systemName: symbol.name)
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(width: size, height: size)
                        .foregroundColor(Color.secondary.opacity(0.5))
                }
            }
        }
    }
}

struct SymbolsView_Previews: PreviewProvider {
    static var previews: some View {
        SymbolsView()
    }
}
