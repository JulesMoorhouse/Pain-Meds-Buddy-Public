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

    init (med: Med, hasChevron: Bool = true) {
        self.med = med
        self.hasChevron = hasChevron
    }
    
    var body: some View {
        HStack {
            MedSymbolView(med: med)

            Spacer()
                .frame(width: 10)

            VStack(alignment: .leading) {
                Text(med.medTitle)
                    .foregroundColor(.primary)
                Text("\(med.remaining) \(med.medForm)")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }

            if hasChevron {
                Spacer()

                ChevronRightView()
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            String(.homeAccessibilityIconRemaining,
                   values: [med.medColor,
                            med.medSymbolLabel,
                            med.medTitle,
                            med.medRemaining,
                            med.medForm])
        )
        .accessibilityIdentifier(.homeAccessibilityIconRemaining)
    }
}

struct MedRowView_Previews: PreviewProvider {
    static var previews: some View {
        MedRowView(med: Med.example, hasChevron: true)
    }
}
