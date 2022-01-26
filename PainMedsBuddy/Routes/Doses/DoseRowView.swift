//
//  DoseRowView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// INFO: This view is a row used on the DoseView

import SwiftUI
import XNavigation

struct DoseRowView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var navigation: Navigation

    @ObservedObject var dose: Dose

    @State private var showEditView = false
    @State private var buttonToggle = false

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
                navigation.pushView(
                    DoseEditView(
                        dataController: dataController,
                        dose: dose)
                        .environmentObject(dataController)
                        .environment(\.managedObjectContext, viewContext))
            }
        }, label: {
            if let med = dose.med {
                VStack {
                    HStack {
                        MedSymbolView(med: med)

                        Spacer()
                            .frame(width: 10)

                        VStack(alignment: .leading) {
                            Text(med.medTitle)
                                .foregroundColor(.primary)
                            Text(dose.doseDisplay)
                                .foregroundColor(.secondary)
                                .font(.caption)
                            Text(dose.doseFormattedTakenTimeShort)
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }

                        Spacer()

                        if !dose.doseDetails.isEmpty {
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
                                    alignment: .topLeading)
                                .padding(.vertical, 2)
                        }
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(
                    InterpolatedStrings.homeAccessibilityIconTaken(dose: dose, med: med)
                )
                .accessibilityIdentifier(.homeAccessibilityIconTaken)
            }
        })
    }
}

struct DoseRowView_Previews: PreviewProvider {
    static var previews: some View {
        DoseRowView(dose: Dose.example)
    }
}
