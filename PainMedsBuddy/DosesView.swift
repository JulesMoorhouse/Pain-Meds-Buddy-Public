//
//  DosesView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// INFO: This view shows all the taken doses of medication

import CoreData
import SwiftUI

struct DosesView: View {
    static let takenTag: String? = "Taken"
    static let notTakenTag: String? = "NotTaken"
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    let showTakenDoses: Bool
    @State var showAddView = false

    let doses: FetchRequest<Dose>
    let meds: [Med]
    
    init(dataController: DataController, meds: [Med], showTakenDoses: Bool) {
        self.showTakenDoses = showTakenDoses
        self.meds = meds
        
        doses = FetchRequest<Dose>(entity: Dose.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Dose.takenDate, ascending: true)
        ], predicate: NSPredicate(format: "taken = %d", showTakenDoses))
    }
    
    // INFO: Results to an array of section arrays
    func resultsToArray(_ result: FetchedResults<Dose>) -> [[Dose]] {
        let dict = Dictionary(grouping: result) { (sequence: Dose) in
            sequence.doseFormattedMYTakenDate
        }

        // INFO: Sort by key aka doseFormattedMYTakenDate
        let sorted = dict.sorted(by: { $0.key > $1.key })

        return sorted.map { $0.value }
    }
    
    func rowsView(section: [Dose]) -> some View {
        ForEach(section, id: \.self) { dose in
            DoseRowView(meds: meds, dose: dose)
        }
        .onDelete { offsets in
            for offset in offsets {
                let item = section[offset]
                dataController.delete(item)
            }
            dataController.save()
            dataController.container.viewContext.processPendingChanges()
        }
    }
    
    var body: some View {
        let data: [[Dose]] = resultsToArray(self.doses.wrappedValue)
        
        return NavigationView {
            List {
                ForEach(data, id: \.self) { (section: [Dose]) in
                    Section(header: Text(section[0].doseFormattedMYTakenDate)) {
                        self.rowsView(section: section)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .background(
                NavigationLink(destination: DoseAddView(meds: meds)
                    .environment(\.managedObjectContext, managedObjectContext)
                    .environmentObject(dataController),
                    isActive: $showAddView) {
                        EmptyView()
                }
            )
            .navigationTitle(showTakenDoses ? "History" : "Missed")
            .toolbar {
                Button(action: { self.showAddView = true }) {
                    Label("Add Dose", systemImage: "plus")
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct DosesView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        DosesView(dataController: dataController, meds: [Med()], showTakenDoses: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
