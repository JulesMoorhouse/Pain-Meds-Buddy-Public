//
//  DosesView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// This view shows all the taken doses of medication

import SwiftUI

struct DosesView: View {
    static let takenTag: String? = "Taken"
    static let notTakenTag: String? = "NotTaken"
    
    let showTakenDoses: Bool
    
    let doses: FetchRequest<Dose>
    
    init(showTakenDoses: Bool) {
        self.showTakenDoses = showTakenDoses
        
        doses = FetchRequest<Dose>(entity: Dose.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Dose.takenDate, ascending: false)
        ], predicate: NSPredicate(format: "taken = %d", showTakenDoses))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(doses.wrappedValue) { dose in
                    DoseRowView(dose: dose)
                }
            }
            .navigationTitle(showTakenDoses ? "History" : "Missed")
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
