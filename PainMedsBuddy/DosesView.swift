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
    
    func resultsToDictionary(_ result: FetchedResults<Dose>) -> [[Dose]] {
        return Dictionary(grouping: result) { ( sequence: Dose) in
            sequence.doseFormattedMYTakenDate
        }.values.map{$0}
    }
    
    func rowsView(section: [Dose]) -> some View {
        ForEach(section, id: \.self) { dose in
            DoseRowView(dose: dose)
        }
    }
    
    var body: some View {
        let data: [[Dose]] = resultsToDictionary(self.doses.wrappedValue)
        return NavigationView {
            List {
                ForEach(data, id: \.self) { (section: [Dose]) in
                    Section(header: Text(section[0].doseFormattedMYTakenDate)) {
                        self.rowsView(section: section)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
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
