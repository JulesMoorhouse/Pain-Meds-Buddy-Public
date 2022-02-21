//
//  DoseRowView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// INFO: This view is a row used on the DoseView

import SwiftUI

struct DoseRowView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var viewContext

    @ObservedObject var dose: Dose

    @State private var showEditView = false
    @State private var buttonToggle = false
    @State private var showSheet = false

    var chevronIcon: ChevronView.Direction {
        let result: ChevronView.Direction
            = dose.elapsed
            ? (buttonToggle ? .up : .bottom)
            : .right
        return result
    }

    var showDetails: Bool {
        dose.elapsed
            && !dose.doseDetails.isEmpty
            && buttonToggle
    }

    var body: some View {
        Button(action: {
            if dose.elapsed {
                buttonToggle.toggle()
            } else {
                showSheet.toggle()
            }
        }, label: {
            if let med = dose.med {
                VStack {
                    HStack {
                        MedSymbolView(symbol: med.medSymbol, colour: med.medColor)

                        Spacer()
                            .frame(width: 10)

                        VStack(alignment: .leading) {
                            Text(med.medTitle)
                                .foregroundColor(.primary)
                            Text(dose.doseDisplay)
                                .foregroundColor(.secondary)
                                .font(.caption)
                            HStack {
                                Text(dose.doseFormattedTakenTimeShort)
                                    .foregroundColor(.secondary)
                                    .font(.caption)

                                if dose.doseElapsed {
                                    Text(InterpolatedStrings
                                        .doseElapsedLabel(dose: dose))
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                }

                                Spacer()
                            }
                        }

                        Spacer()

                        if !dose.doseElapsed || !dose.doseDetails.isEmpty {
                            ChevronView(
                                direction: chevronIcon)
                        }
                    }

                    if showDetails {
                        VStack {
                            Divider()

                            Text(dose.doseDetails)
                                .foregroundColor(.secondary)
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                                .frame(
                                    minWidth: 0,
                                    maxWidth: .infinity,
                                    minHeight: 0,
                                    maxHeight: .infinity,
                                    alignment: .topLeading
                                )
                                .padding(.vertical, 2)
                        }
                    }
                }
                .sheet(isPresented: $showSheet) {
                    DoseEditView(
                        dataController: dataController,
                        dose: dose
                    )
                    .allowAutoDismiss(false)
                    .environmentObject(dataController)
                    .environment(\.managedObjectContext, viewContext)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(
                    InterpolatedStrings.homeAccessibilityIconTaken(dose: dose, med: med)
                )
                .accessibilityIdentifier(.homeAccessibilityIconTaken)
            }
        })
        .contentShape(Rectangle())
    }
}

struct DoseRowView_Previews: PreviewProvider {
    static var previews: some View {
        DoseRowView(dose: Dose.example)
    }
}
