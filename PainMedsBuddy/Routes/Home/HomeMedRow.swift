//
//  HomeMedRow.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI
import XNavigation

struct HomeMedRow: View {
    @EnvironmentObject var navigation: Navigation

    @ObservedObject var med: Med

    var detail: some View {
        VStack(alignment: .leading) {
            Text(med.medTitle)
                .foregroundColor(.primary)
            Text(med.medDisplay)
                .foregroundColor(.secondary)
                .font(.caption)
            Text(med.medFormattedLastTakenDate)
                .foregroundColor(.secondary)
                .font(.caption)
        }
    }

    var body: some View {
        HStack {
            MedSymbolView(med: med)

            Spacer()
                .frame(width: 10)

            detail

            Spacer()

            Button(action: {
                navigation.pushView(
                    DoseAddView(med: med),
                    animated: true
                )
            }, label: {
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
            InterpolatedStrings.homeAccessibilityIconTakeNow(med: med)
        )
        .accessibilityIdentifier(.homeAccessibilityIconTakeNow)
    }
}

struct HomeMedRow_Previews: PreviewProvider {
    static var previews: some View {
        HomeMedRow(med: Med.example)
    }
}
