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
    static let medsTag: String? = "Medications"
    static let medsIcon: String = SFSymbol.pillsFill.systemName

    @StateObject private var viewModel: ViewModel
    @EnvironmentObject private var navigation: Navigation
    @EnvironmentObject private var dataController: DataController
    @EnvironmentObject private var tabBarHandler: TabBarHandler
    @EnvironmentObject private var presentableToast: PresentableToast

    var items: [Med] {
        viewModel.meds.allMeds.filter { !$0.hidden}.sortedItems(using: viewModel.sortOrder)
    }

    var medsList: some View {
        List {
            ForEach(items, id: \.self) { med in
                Button(action: {
                    navigation.pushView(
                        MedEditView(
                            dataController: dataController,
                            med: med,
                            add: false,
                            hasRelationship: viewModel.hasRelationship(med: med)
                        ),
                        animated: true
                    )
                }, label: {
                    MedRowView(med: med)
                })
            }
            .onDelete { offsets in
                viewModel.deleteMed(offsets, items: items)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .disabled(viewModel.showingSortOrder == true)
    }

    var addMedToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack {
                Text("")
                    .accessibilityHidden(true)
                Button(action: {
                    navigation.pushView(
                        MedAddView()
                            .environmentObject(dataController),
                        animated: true
                    )
                }, label: {
                    // INFO: In iOS 14.3 VoiceOver has a glitch that reads the label
                    // "Add Med" as "Add" no matter what accessibility label
                    // we give this toolbar button when using a label.
                    // As a result, when VoiceOver is running, we use a text
                    // view for the button instead, forcing a correct reading
                    // without losing the original layout.
                    if UIAccessibility.isVoiceOverRunning {
                        Text(.medEditAddMed)
                            .accessibilityIdentifier(.medEditAddMed)
                    } else {
                        Label(.medEditAddMed, systemImage: SFSymbol.plus.systemName)
                            .accessibilityElement()
                            .accessibility(addTraits: .isButton)
                            .accessibilityLabel(.medEditAddMed)
                            .accessibilityIdentifier(.medEditAddMed)
                    }
                })
            }
        }
    }

    var sortToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if !viewModel.meds.isEmpty {
                HStack {
                    Text("")
                        .accessibilityHidden(true)

                    Button(action: {
                        viewModel.showingSortOrder = true
                    }, label: {
                        Label(.commonSort, systemImage: SFSymbol.arrowUpArrowDown.systemName)
                            .accessibilityElement()
                            .accessibility(addTraits: .isButton)
                            .accessibilityIdentifier(.commonSort)
                    })
                }
            }
        }
    }

    var body: some View {
        NavigationViewChild {
            Group {
                if viewModel.meds.isEmpty {
                    PlaceholderView(
                        string: .commonEmptyView,
                        imageString: MedsView.medsIcon
                    )
                } else {
                    ZStack {
                        medsList
                    }
                }
            }
            .toolbar {
                addMedToolbarItem
                sortToolbarItem
            }
            .actionSheet(isPresented: $viewModel.showingSortOrder) {
                ActionSheet(title: Text(Strings.sortSortOrder.rawValue), buttons: [
                    .default(Text(Strings.sortOptimised.rawValue)) { viewModel.sortOrder = .optimised },
                    .default(Text(Strings.sortCreatedDate.rawValue)) { viewModel.sortOrder = .creationDate },
                    .default(Text(Strings.sortTitle.rawValue)) { viewModel.sortOrder = .title },
                    .cancel(),
                ])
            }
            .navigationTitle(Strings.tabTitleMedications.rawValue)
            .navigationBarAccessibilityIdentifier(.tabTitleMedications)
            .toasted(show: $presentableToast.show, data: $presentableToast.data)

            PlaceholderView(
                string: .medsPleaseSelect,
                imageString: MedsView.medsIcon
            )
        }
        .onAppear(perform: {
            self.tabBarHandler.showTabBar()
        })
    }

    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)

        _viewModel = StateObject(wrappedValue: viewModel)
    }
}

struct MedicationsView_Previews: PreviewProvider {
    static var previews: some View {
        MedsView(dataController: DataController.preview)
    }
}
