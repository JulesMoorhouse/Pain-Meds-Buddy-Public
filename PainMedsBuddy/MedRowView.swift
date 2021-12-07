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
                Text(med.medDefaultTitle)
                    .foregroundColor(Color(med.color ?? Med.defaultColor))
                Text("\(med.remaining) \(med.medForm)")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
    }
}

struct MedRowView_Previews: PreviewProvider {
    static var previews: some View {
        MedRowView(med: Med.example)
    }
}
