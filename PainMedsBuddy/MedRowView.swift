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

    var body: some View {
        HStack {
            MedSymbolView(med: med)

            Spacer()
                .frame(width: 10)

            VStack(alignment: .leading) {
                Text(med.medTitle)
                    // .foregroundColor(Color(med.color ?? Med.defaultColor))
                    .foregroundColor(.primary)
                Text("\(med.remaining) \(med.medForm)")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            "\(med.medColor) \(med.medSymbolLabel) icon, \(med.medTitle), \(med.remaining) \(med.medForm) remaining"
        )
    }
}

struct MedRowView_Previews: PreviewProvider {
    static var previews: some View {
        MedRowView(med: Med.example)
    }
}
