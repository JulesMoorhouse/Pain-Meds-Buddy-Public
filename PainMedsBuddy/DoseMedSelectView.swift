//
//  DoseMedSelectView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI
import XNavigation

struct DoseMedSelectView: View { // DestinationView {
    // var navigationBarTitleConfiguration = NavigationBarTitleConfiguration(
    //    title: String(.selectMedSelectMed),
    //    displayMode: .automatic)

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

    var sortToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                self.showingSortOrder = true
            }, label: {
                Label(.commonSort, systemImage: "arrow.up.arrow.down")
            })
        }
    }

    var body: some View {
        ZStack {
            List {
                ForEach(Array(items.enumerated()), id: \.offset) { index, med in
                    medRow(med: med, index: index)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .disabled($showingSortOrder.wrappedValue == true)

            if $showingSortOrder.wrappedValue == true {
                MedSortView(sortOrder: $sortOrder, showingSortOrder: $showingSortOrder)
            }
        }
        // .navigationBarTitle(configuration: navigationBarTitleConfiguration)
        .navigationTitle(Strings.selectMedSelectMed.rawValue)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Color.clear // BugFix: Back button dissapears
            }
            sortToolbarItem
        }
    }

    func medRow(med: Med, index: Int) -> some View {
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

struct DoseMedSelectView_Previews: PreviewProvider {
    static var previews: some View {
        DoseMedSelectView(selectedMed: .constant(Med()))
    }
}
