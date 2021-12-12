//
//  DoseRowView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// INFO: This view is a row used on the DoseView

import SwiftUI

struct DoseRowView: View {
    let meds: [Med]

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
                    // TODO: Replace with something other than example
                    MedSymbolView(med: dose.med ?? Med.example)

                    Spacer()
                        .frame(width: 10)

                    VStack(alignment: .leading) {
                        Text(dose.med?.medTitle ?? MedDefault.title)
                            // .foregroundColor(Color(dose.med?.color ?? Med.defaultColor))
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

struct DoseRowView_Previews: PreviewProvider {
    static var previews: some View {
        DoseRowView(meds: [Med()], dose: Dose.example)
    }
}
