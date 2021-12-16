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
    static let inProgressTag: String? = "InProgress"
    static let historyTag: String? = "History"
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    let showElapsedDoses: Bool
    @State private var showAddView = false

    let doses: FetchRequest<Dose>
    
    var medsCount: Int {
        let fetchRequest: NSFetchRequest<Med> = NSFetchRequest<Med>(entityName: "Med")
        return dataController.count(for: fetchRequest)
    }
    
    init(dataController: DataController, showElapsedDoses: Bool) {
        self.showElapsedDoses = showElapsedDoses
        
        doses = FetchRequest<Dose>(entity: Dose.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Dose.takenDate, ascending: true)
        ], predicate: NSPredicate(format: "elapsed = %d", showElapsedDoses))
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
            DoseRowView(dose: dose)
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
            Group {
                if data.isEmpty {
                    PlaceholderView(text: medsCount > 0 ? "There's nothing here right now!" : "Please add a medication before adding dose!",
                                    imageString: "pills")
                } else {
                    List {
                        ForEach(data, id: \.self) { (section: [Dose]) in
                            Section(header: Text(section[0].doseFormattedMYTakenDate)) {
                                self.rowsView(section: section)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .background(
                NavigationLink(destination: DoseAddView(med: nil)
                    .environment(\.managedObjectContext, managedObjectContext)
                    .environmentObject(dataController),
                    isActive: $showAddView) {
                        EmptyView()
                }
            )
            .navigationTitle(showElapsedDoses ? NSLocalizedString("History", comment: "") : NSLocalizedString("In Progress", comment: ""))
            .toolbar {
                if medsCount > 0 {
                    Button(action: {
                        self.showAddView = true
                    
                    }) {
                        Label("Add Dose", systemImage: "plus")
                    }
                }
            }
            
            PlaceholderView(text: medsCount > 0 ? "Please select or add a dose" : "Please add a medication before adding dose!", imageString: "eyedropper.halffull")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct DosesView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        DosesView(dataController: dataController, showElapsedDoses: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
