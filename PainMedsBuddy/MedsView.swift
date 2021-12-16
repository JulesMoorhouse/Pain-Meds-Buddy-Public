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
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: Med.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Med.sequence, ascending: true)],
                  predicate: nil) var meds: FetchedResults<Med>

    @State private var showingSortOrder = false
    @State private var sortOrder = Med.SortOrder.optimzed
    @State private var showAddView = false
    @State private var canDelete = false
    @State private var showDeleteDenied = false

//    var items: [Med] {
//        DataController.resultsToArray(meds).allMeds.sortedItems(using: sortOrder)
//    }
    
    var body: some View {
        let items: [Med] = DataController.resultsToArray(meds).allMeds.sortedItems(using: sortOrder)
        
        return NavigationView {
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
                                let deleteItems = offsets.map { items[$0] }
                                
                                let count = dataController.check(for: deleteItems)
                                if count == 0 {
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
                                } else {
                                    showDeleteDenied.toggle()
                                }
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
                        Label(NSLocalizedString("Add Med", comment: ""), systemImage: "plus")
                    }
                }
                        
                ToolbarItem(placement: .navigationBarLeading) {
                    if meds.count > 0 {
                        Button(action: {
                            self.showingSortOrder = true
                        }) {
                            Label(NSLocalizedString("Sort", comment: ""), systemImage: "arrow.up.arrow.down")
                        }
                    }
                }
            }
            .navigationTitle("Medications")
            .alert(isPresented: $showDeleteDenied) {
                Alert(title: Text("Delete dose"),
                      message: Text("Sorry you can not delete meds used with doses!"),
                      dismissButton: .default(Text("OK")))
            }
            
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
