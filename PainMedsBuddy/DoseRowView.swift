//
//  DoseRowView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// This view is a row used on the DoseView

import SwiftUI

struct DoseRowView: View {
    let meds: [Med]

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var dose: Dose

    @State var showEditView = false

    var body: some View {
        NavigationLink(destination:
            DoseEditView(meds: meds, dose: dose, add: false)
                .environmentObject(dataController)
                .environment(\.managedObjectContext, viewContext), isActive: $showEditView) {
                VStack(alignment: .leading) {
                    Text(dose.doseTitle)
                        .foregroundColor(Color(dose.med?.color ?? "Dark Blue"))
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

struct DoseRowView_Previews: PreviewProvider {
    static var previews: some View {
        DoseRowView(meds: [Med()], dose: Dose.example)
    }
}
