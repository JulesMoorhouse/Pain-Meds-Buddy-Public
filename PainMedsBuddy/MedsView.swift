//
//  MedicationsView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// INFO: This view shows all the available medication

import CoreData
import SwiftUI
import XNavigation

struct MedsView: View {
    static let MedsTag: String? = "Medications"

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var navigation: Navigation

    @FetchRequest(entity: Med.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Med.sequence, ascending: true)],
                  predicate: nil) var meds: FetchedResults<Med>

    @State private var showingSortOrder = false
    @State private var sortOrder = Med.SortOrder.optimzed
    @State private var canDelete = false
    @State private var showDeleteDenied = false

    var items: [Med] {
        DataController.resultsToArray(meds).allMeds.sortedItems(using: sortOrder)
    }

    var medsList: some View {
        List {
            ForEach(items, id: \.self) { med in
                Button(action: {
                    navigation.pushView(
                        MedEditView(med: med, add: false),
                        animated: true
                    )
                }, label: {
                    MedRowView(med: med)
                })
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
            Button(action: {
                navigation.pushView(
                    MedAddView()
                        .environment(\.managedObjectContext, managedObjectContext)
                        .environmentObject(dataController),
                    animated: true
                )
            }, label: {
                if UIAccessibility.isVoiceOverRunning {
                    Text(.medEditAddMed)
                } else {
                    Label(.medEditAddMed, systemImage: "plus")
                }
            })
        }
    }

    var sortToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if meds.count > 0 {
                Button(action: {
                    self.showingSortOrder = true
                }, label: {
                    Label(.commonSort, systemImage: "arrow.up.arrow.down")
                })
            }
        }
    }

    var body: some View {
//        let items: [Med] = DataController.resultsToArray(meds).allMeds.sortedItems(using: sortOrder)

        return NavigationView {
            Group {
                if self.meds.isEmpty {
                    PlaceholderView(text: Strings.commonEmptyView.rawValue,
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
            .toolbar {
                addMedToolbarItem
                sortToolbarItem
            }
            .navigationTitle(Strings.tabTitleMedication.rawValue)
            .alert(isPresented: $showDeleteDenied) {
                Alert(title: Text(.medEditDeleteMed),
                      message: Text(.medsSorryUsed),
                      dismissButton: .default(Text(.commonOK)))
            }

            PlaceholderView(text: Strings.medsPleaseSelect.rawValue,
                            imageString: "eyedropper.halffull")
        }
    }

    func deleteMed(_ offsets: IndexSet, items: [Med]) {
        let deleteItems = offsets.map { items[$0] }

        let count = dataController.anyRelationships(for: deleteItems)
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
