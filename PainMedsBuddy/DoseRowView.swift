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

    var body: some View {
        Button(action: {
            navigation.pushView(DoseEditView(dataController: dataController, dose: dose, add: false)
                .environmentObject(dataController)
                .environment(\.managedObjectContext, viewContext))
        }) {
            if let med = dose.med {
                HStack {
                    // TODO: Replace with something other than example
                    MedSymbolView(med: med)

                    Spacer()
                        .frame(width: 10)

                    VStack(alignment: .leading) {
                        Text(med.medTitle)
                            // .foregroundColor(Color(dose.medColor))
                            .foregroundColor(.primary)
                        Text(dose.doseDisplay)
                            .foregroundColor(.secondary)
                            .font(.caption)
                        Text(dose.doseFormattedTakenDate)
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }

                    Spacer()

                    ChevronRightView()
                }

                .accessibilityElement(children: .ignore)
                .accessibilityLabel(
                    .homeAccessibilityIconTaken,
                    values: [med.medColor,
                             med.medSymbolLabel,
                             med.medTitle,
                             med.medDisplay,
                             med.medFormattedLastTakenDate])
            }
        }
    }
}

struct DoseRowView_Previews: PreviewProvider {
    static var previews: some View {
        DoseRowView(dose: Dose.example)
    }
}
