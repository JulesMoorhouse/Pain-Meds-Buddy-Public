//
//  TwoColumnView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct TwoColumnView: View {
    let col1: LocalizedStringKey
    let col2: String
    let hasChevron: Bool

    var body: some View {
        Group {
            Text(col1)
                .foregroundColor(.secondary)
            Spacer()
            Text(col2)

            if hasChevron {
                ChevronView()
            }
        }
    }
}

struct TwoColumnView_Previews: PreviewProvider {
    static var col1: LocalizedStringKey = "Col1"
    static var col2 = "Col2"

    static var previews: some View {
        TwoColumnView(col1: col1, col2: col2, hasChevron: true)
    }
}
