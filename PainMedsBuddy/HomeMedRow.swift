//
//  HomeMedRow.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct HomeMedRow: View {
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
                Text(med.medDisplay)
                    .foregroundColor(.secondary)
                    .font(.caption)
                Text(med.medFormattedLastTakenDate)
                    .foregroundColor(.secondary)
                    .font(.caption)
            }

            Spacer()

            NavigationLink(destination:
                DoseAddView(med: med),
                label: {
                    ButtonBorderView(
                        text: Strings.homeTakeNext.rawValue,
                        width: 80,
                        font: .footnote,
                        padding: 8
                    )
                })
            Spacer()
                .frame(width: 10)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(
            String(.homeAccessibilityIconTakeNow,
                   values: [med.medColor,
                            med.medSymbolLabel,
                            med.medTitle,
                            med.medDisplay,
                            med.medFormattedLastTakenDate])
        )
    }
}

struct HomeMedRow_Previews: PreviewProvider {
    static var previews: some View {
        HomeMedRow(med: Med.example)
    }
}
