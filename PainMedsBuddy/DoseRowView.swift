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

    var body: some View {
        NavigationLink(destination:
            DoseEditView(dataController: dataController, dose: dose, add: false)
                .environmentObject(dataController)
                .environment(\.managedObjectContext, viewContext), isActive: $showEditView) {
                HStack {
                    if let med = dose.med {
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
                    }
                }
        }
    }
}

struct DoseRowView_Previews: PreviewProvider {
    static var previews: some View {
        DoseRowView(dose: Dose.example)
    }
}
