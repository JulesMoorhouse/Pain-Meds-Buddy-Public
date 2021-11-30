//
//  DoseRowView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// This view is a row used on the DoseView

import SwiftUI

struct DoseRowView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var dose: Dose

    var body: some View {
        NavigationLink(destination:
            DoseEditView(dataController: dataController, dose: dose)
                .environmentObject(dataController)
        ) {
            Text(dose.doseTitle)
        }
    }
}

struct DoseRowView_Previews: PreviewProvider {
    static var previews: some View {
        DoseRowView(dose: Dose.example)
    }
}
