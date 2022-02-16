//
//  HomeMedRow.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct HomeMedRow: View {
    @ObservedObject var med: Med

    @State private var showSheet = false

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
            MedSymbolView(symbol: med.medSymbol, colour: med.medColor)

            Spacer()
                .frame(width: 10)

            detail

            Spacer()

            Button(action: {
                showSheet.toggle()
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
        .sheet(isPresented: $showSheet) {
            DoseAddView(med: med)
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
