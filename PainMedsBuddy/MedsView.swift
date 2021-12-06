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
            ZStack {
                List {
                    ForEach(items(), id: \.self) { med in
                        NavigationLink(destination: MedEditView(med: med)) {
                            MedRowView(med: med)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .disabled($showingSortOrder.wrappedValue == true)
        
                if $showingSortOrder.wrappedValue == true {
                    MedSortView(sortOrder: $sortOrder, showingSortOrder: $showingSortOrder)
                }
            }
            .navigationTitle("Medications")
            .toolbar {
                Button(action: {
                    self.showingSortOrder = true
                }) {
                    Label("Sort", systemImage: "arrow.up.arrow.down")
                }
            }
        }
    }
    
    // TODO: This will move later
    func items() -> [Med] {
        switch sortOrder {
        case .title:
            return meds.allMeds.sorted { $0.medDefaultTitle < $1.medDefaultTitle }
        case .creationDate:
            return meds.allMeds.sorted { $0.medCreationDate < $1.medCreationDate }
        default:
            return meds.allMedsDefaultSorted
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
