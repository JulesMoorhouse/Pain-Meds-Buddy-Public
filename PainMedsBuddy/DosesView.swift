//
//  DosesView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct DosesView: View {
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
                    Section(header: Text(dose.drug?.title ?? "")) {
                        Text(dose.taken == true ? "Taken" : "Not taken")
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
