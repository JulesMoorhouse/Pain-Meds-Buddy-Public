//
//  MedSymbolView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct MedSymbolView: View {
    @ObservedObject var med: Med
    
    var body: some View {
        Image(systemName: med.medSymbol)
            .font(.title)
            .foregroundColor(Color(med.color ?? Med.defaultColor))
            .frame(width: 45, height: 45)
    }
}

struct MedSymbolView_Previews: PreviewProvider {
    static var previews: some View {
        MedSymbolView(med: Med())
    }
}
