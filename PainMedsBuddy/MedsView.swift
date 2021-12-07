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
    
    let meds: [Med]
    
    @State private var showingSortOrder = false
    @State private var sortOrder = Med.SortOrder.optimzed
    
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
                                NavigationLink(destination: MedEditView(med: med)) {
                                    MedRowView(med: med)
                                }
                            }
                            // TODO: Add on delete, rememeberto use sortedItem(using func
                        }
                        .listStyle(InsetGroupedListStyle())
                        .disabled($showingSortOrder.wrappedValue == true)
        
                        if $showingSortOrder.wrappedValue == true {
                            MedSortView(sortOrder: $sortOrder, showingSortOrder: $showingSortOrder)
                        }
                    }
                    .toolbar {
                        //TODO: Add add view
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
        MedsView(meds: [Med()])
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
