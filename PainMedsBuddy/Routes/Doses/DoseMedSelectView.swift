//
//  DoseMedSelectView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI
import XNavigation

struct DoseMedSelectView: View, DestinationView {
    var navigationBarTitleConfiguration = NavigationBarTitleConfiguration(
        title: String(.selectMedSelectMed),
        displayMode: .automatic
    )

    @StateObject private var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var tabBarHandler: TabBarHandler

    @Binding var selectedMed: Med

    var items: [Med] {
        viewModel.meds.allMeds.sortedItems(using: viewModel.sortOrder)
    }

    var sortToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                viewModel.showingSortOrder = true
            }, label: {
                Label(.commonSort, systemImage: SFSymbol.arrowUpArrowDown.systemName)
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
            .disabled($viewModel.showingSortOrder.wrappedValue == true)
        }
        .navigationBarTitle(configuration: navigationBarTitleConfiguration)
        .navigationBarAccessibilityIdentifier(.selectMedSelectMed)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Color.clear // BugFix: Back button disappears
            }
            sortToolbarItem
        }
        .actionSheet(isPresented: $viewModel.showingSortOrder) {
            ActionSheet(title: Text(Strings.sortSortOrder.rawValue), buttons: [
                .default(Text(Strings.sortOptimised.rawValue)) { viewModel.sortOrder = .optimised},
                .default(Text(Strings.sortCreatedDate.rawValue)) { viewModel.sortOrder = .creationDate },
                .default(Text(Strings.sortTitle.rawValue)) { viewModel.sortOrder = .title },
                .cancel()
            ])
        }
        .onAppear(perform: {
            self.tabBarHandler.hideTabBar()
        })
    }

    func medRow(med: Med, index: Int) -> some View {
        HStack {
            MedRowView(med: med, hasChevron: false)

            Spacer()

            if self.selectedMed == items[index] {
                Image(systemName: SFSymbol.checkmark.systemName)
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

    init(selectedMed: Binding<Med>, dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)

        _viewModel = StateObject(wrappedValue: viewModel)
        _selectedMed = selectedMed
    }
}

struct DoseMedSelectView_Previews: PreviewProvider {
    static var previews: some View {
        DoseMedSelectView(selectedMed: .constant(Med()), dataController: DataController.preview)
    }
}
