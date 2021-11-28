//
//  DosesView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct DosesView: View {
    static let takenTag: String? = "Taken"
    static let notTakenTag: String? = "NotTaken"
    
    let showTakenDoses: Bool
    
    let doses: FetchRequest<Doses>
    
    init(showTakenDoses: Bool) {
        self.showTakenDoses = showTakenDoses
        
        doses = FetchRequest<Doses>(entity: Doses.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Doses.takenDate, ascending: false)
        ], predicate: NSPredicate(format: "taken = %d", showTakenDoses))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(doses.wrappedValue) { dose in
                    if let med = dose.medication {
                        Section(header: Text(med.medicationTitle)) {
                                MedicationRowView(medication: med)
                       }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(showTakenDoses ? "Taken Meds" : "Meds to take")
        }
    }
}

struct DosesView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        DosesView(showTakenDoses: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
