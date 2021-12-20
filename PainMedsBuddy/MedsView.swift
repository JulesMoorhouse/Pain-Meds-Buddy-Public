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

    var items: [Med] {
        DataController.resultsToArray(meds).allMeds.sortedItems(using: sortOrder)
    }
    
    var medsList: some View {
        List {
            ForEach(items, id: \.self) { med in
                NavigationLink(destination: MedEditView(med: med, add: false)) {
                    MedRowView(med: med)
                }
            }
            .onDelete { offsets in
                deleteMed(offsets, items: items)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .disabled($showingSortOrder.wrappedValue == true)
    }
    
    var addMedToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { self.showAddView = true }) {
                if UIAccessibility.isVoiceOverRunning {
                    Text("Add Med")
                } else {
                    Label("Add Med", systemImage: "plus")
                }
            }
        }
    }
    
    var sortToolbarItem: some ToolbarContent {
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
    
    var body: some View {
//        let items: [Med] = DataController.resultsToArray(meds).allMeds.sortedItems(using: sortOrder)
        
        return NavigationView {
            Group {
                if self.meds.isEmpty {
                    PlaceholderView(text: "There's nothing here right now!",
                                    imageString: "pills")
                } else {
                    ZStack {
                        medsList
        
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
                addMedToolbarItem
                sortToolbarItem
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
    
    func deleteMed(_ offsets: IndexSet, items: [Med]) {
        let deleteItems = offsets.map { items[$0] }
        
        let count = dataController.AnyRelationships(for: deleteItems)
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

struct MedicationsView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        MedsView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
