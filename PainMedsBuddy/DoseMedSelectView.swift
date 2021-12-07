//
//  DoseMedSelectView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct DoseMedSelectView: View {
    @Environment(\.presentationMode) var presentationMode

    let meds: [Med]

    @Binding var selectedMed: Med
    @State private var showingSortOrder = false
    @State private var sortOrder = Med.SortOrder.optimzed

    init(meds: [Med], selectedMed: Binding<Med>) {
        self.meds = meds.allMedsDefaultSorted
        _selectedMed = selectedMed
    }

    var body: some View {
        ZStack {
            List {
                ForEach(Array(self.meds.sortedItems(using: sortOrder).enumerated()), id: \.offset) { index, med in
                    HStack {
                        MedRowView(med: med)

                        Spacer()

                        if self.selectedMed == meds[index] {
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
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
        }
    }
}

struct DoseMedSelectView_Previews: PreviewProvider {
    static var previews: some View {
        DoseMedSelectView(meds: [Med()], selectedMed: .constant(Med()))
    }
}
