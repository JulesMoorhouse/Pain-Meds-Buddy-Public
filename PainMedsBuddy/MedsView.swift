//
//  MedicationsView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// INFO: This view shows all the available medication

import CoreData
import SwiftUI

struct MedsView: View {
    static let MedsTag: String? = "Medications"
    
    @FetchRequest(entity: Med.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Med.sequence, ascending: true)],
                  predicate: nil) var meds: FetchedResults<Med>
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var showingSortOrder = false
    @State private var sortOrder = Med.SortOrder.optimzed
    @State private var showAddView = false
    
    var items: [Med] {
        DataController.resultsToArray(meds).allMeds.sortedItems(using: sortOrder)
    }
    
    var body: some View {
        NavigationView {
            Group {
                if self.meds.isEmpty {
                    PlaceholderView(text: "There's nothing here right now!",
                                    imageString: "pills")
                } else {
                    ZStack {
                        List {
                            ForEach(items, id: \.self) { med in
                                NavigationLink(destination: MedEditView(med: med, add: false)) {
                                    MedRowView(med: med)
                                }
                            }
                            .onDelete { offsets in                                
                                for offset in offsets {
                                    let item = items[offset]
                                    dataController.delete(item)
                                    
                                    // Bug fix
//                                    if let itemToRemoveIndex = self.meds.firstIndex(of: item) {
//                                        self.meds.remove(at: itemToRemoveIndex)
//                                    }
                                }
                                dataController.save()
                                dataController.container.viewContext.processPendingChanges()
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                        .disabled($showingSortOrder.wrappedValue == true)
        
                        if $showingSortOrder.wrappedValue == true {
                            MedSortView(sortOrder: $sortOrder, showingSortOrder: $showingSortOrder)
                        }
                    }
                }
            }
            .background(
                NavigationLink(destination: MedAddView()
                    .environment(\.managedObjectContext, managedObjectContext)
                    .environmentObject(dataController),
                    isActive: $showAddView) {
                        EmptyView()
                }
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { self.showAddView = true }) {
                        Label("Add Med", systemImage: "plus")
                    }
                }
                        
                ToolbarItem(placement: .navigationBarLeading) {
                    if meds.count > 0 {
                        Button(action: {
                            self.showingSortOrder = true
                        }) {
                            Label("Sort", systemImage: "arrow.up.arrow.down")
                        }
                    }
                }
            }
            .navigationTitle("Medications")
            
            PlaceholderView(text: "Please select or add a medication", imageString: "eyedropper.halffull")
        }
    }
}

struct MedicationsView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        MedsView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
