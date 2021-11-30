//
//  TwoColumnView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct TwoColumnView: View {
    let col1: String
    let col2: String

    var body: some View {
        Group {
            Text(col1)
            Spacer()
            Text(col2)
                .foregroundColor(.secondary)
        }
    }
}

struct TwoColumnView_Previews: PreviewProvider {
    static var col1 = "Col1"
    static var col2 = "Col2"
    
    static var previews: some View {
        TwoColumnView(col1: col1, col2: col2)
    }
}
