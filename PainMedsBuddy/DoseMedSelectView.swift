//
//  DoseMedSelectView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct DoseMedSelectView: View {
    @Environment(\.presentationMode) var presentationMode

    @FetchRequest(entity: Med.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Med.sequence, ascending: true)],
                  predicate: nil) var meds: FetchedResults<Med>

    @Binding var selectedMed: Med
    @State private var showingSortOrder = false
    @State private var sortOrder = Med.SortOrder.optimzed

    var items: [Med] {
        DataController.resultsToArray(meds).allMeds.sortedItems(using: sortOrder)
    }

    init(selectedMed: Binding<Med>) {
        // meds2.allMedsDefaultSorted

        _selectedMed = selectedMed
    }

    var body: some View {
        ZStack {
            List {
                ForEach(Array(items.enumerated()), id: \.offset) { index, med in
                    HStack {
                        MedRowView(med: med)

                        Spacer()

                        if self.selectedMed == items[index] {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .foregroundColor(.primary)
                    .onTapGesture {
                        self.selectedMed = med
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .disabled($showingSortOrder.wrappedValue == true)

            if $showingSortOrder.wrappedValue == true {
                MedSortView(sortOrder: $sortOrder, showingSortOrder: $showingSortOrder)
            }
        }
        .navigationTitle("Select Med")
        .toolbar {
            Button(action: {
                self.showingSortOrder = true
            }) {
                Label(NSLocalizedString("Sort", comment: ""), systemImage: "arrow.up.arrow.down")
            }
        }
    }
}

struct DoseMedSelectView_Previews: PreviewProvider {
    static var previews: some View {
        DoseMedSelectView(selectedMed: .constant(Med()))
    }
}
