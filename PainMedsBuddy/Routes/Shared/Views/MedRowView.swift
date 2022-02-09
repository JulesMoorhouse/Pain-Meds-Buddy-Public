//
//  MedRowView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// INFO: This view is a row shown on the MedicationView.

import SwiftUI

struct MedRowView: View {
    @ObservedObject var med: Med
    let hasChevron: Bool

    private let remainingFormWord: String

    var body: some View {
        HStack {
            MedSymbolView(symbol: med.medSymbol, colour: med.medColor)

            Spacer()
                .frame(width: 10)

            VStack(alignment: .leading) {
                Text(med.medTitle)
                    .foregroundColor(.primary)
                Text("\(med.medRemaining) \(remainingFormWord)")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }

            if hasChevron {
                Spacer()

                ChevronView()
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            InterpolatedStrings.homeAccessibilityIconRemaining(med: med)
        )
        .accessibilityIdentifier(.homeAccessibilityIconRemaining)
    }
    
    init(med: Med, hasChevron: Bool = true) {
        self.med = med
        self.hasChevron = hasChevron

        remainingFormWord
            = Med.formWord(
                num: Int(med.medRemaining) ?? Int(truncating: MedDefault.remaining),
                word: med.form ?? ""
            )
    }
}

struct MedRowView_Previews: PreviewProvider {
    static var previews: some View {
        MedRowView(med: Med.example, hasChevron: true)
    }
}
