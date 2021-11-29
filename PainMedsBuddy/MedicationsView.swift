//
//  MedicationsView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// This view shows all the available medication

import SwiftUI

struct MedicationsView: View {
    static let MedicationsTag: String? = "Medications"
    
    let meds: FetchRequest<Med>
    
    init() {
        meds = FetchRequest<Med>(entity: Med.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Med.sequence, ascending: false)
        ])
    }
    var body: some View {
        NavigationView {
            List {
                ForEach(meds.wrappedValue) { med in
                    MedsRowView(med: med)
                }
            }
            .navigationTitle("Medications")
        }
    }
}

struct MedicationsView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        MedicationsView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
