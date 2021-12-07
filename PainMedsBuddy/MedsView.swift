//
//  MedicationsView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// INFO: This view shows all the available medication

import SwiftUI

struct MedsView: View {
    static let MedsTag: String? = "Medications"
    
    @State private var meds: [Med]
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var showingSortOrder = false
    @State private var sortOrder = Med.SortOrder.optimzed
    @State private var showAddView = false
    
    init(meds: [Med]) {
        self.meds = meds.allMedsDefaultSorted
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
                            ForEach(self.meds.sortedItems(using: sortOrder), id: \.self) { med in
                                NavigationLink(destination: MedEditView(med: med, add: false)) {
                                    MedRowView(med: med)
                                }
                            }
                            .onDelete { offsets in
                                let allItems = self.meds.sortedItems(using: sortOrder)
                                
                                for offset in offsets {
                                    let item = allItems[offset]
                                    dataController.delete(item)
                                    
                                    // Bug fix
                                    if let itemToRemoveIndex = self.meds.firstIndex(of: item) {
                                        self.meds.remove(at: itemToRemoveIndex)
                                    }
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
                            Button(action: {
                                self.showingSortOrder = true
                            }) {
                                Label("Sort", systemImage: "arrow.up.arrow.down")
                            }
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
        MedsView(meds: [Med()])
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
