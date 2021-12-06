//
//  MedicationsView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// This view shows all the available medication

import SwiftUI

struct MedsView: View {
    static let MedsTag: String? = "Medications"
    
    let meds: [Med]
    
    init(meds: [Med]) {
        self.meds = meds.allMeds()
    }
    var body: some View {
        NavigationView {
            List {
                ForEach(meds, id: \.self) { med in
                    MedRowView(med: med)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Medications")
        }
    }
}

struct MedicationsView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        MedsView(meds: [Med()])
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
