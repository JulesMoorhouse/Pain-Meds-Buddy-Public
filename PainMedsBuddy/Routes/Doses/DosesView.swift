//
//  DosesView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// INFO: This view shows all the taken doses of medication

import CoreData
import SimpleToast
import SwiftUI
import XNavigation

struct DosesView: View {
    static let inProgressTag: String? = "InProgress"
    static let inProgressIcon: String = SFSymbol.arrowTriangle2CirclePath.systemName

    static let historyTag: String? = "History"
    static let historyIcon: String = SFSymbol.checkmark.systemName

    @StateObject private var viewModel: ViewModel
    @EnvironmentObject private var navigation: Navigation
    @EnvironmentObject private var tabBarHandler: TabBarHandler
    @EnvironmentObject private var presentableToast: PresentableToast

    func rowsView(section: [Dose]) -> some View {
        ForEach(section, id: \.self) { dose in
            DoseRowView(dose: dose)
        }
        .onDelete { offsets in
            viewModel.deleteDose(offsets, from: section)
        }
    }

    var body: some View {
        let data: [[Dose]] = viewModel.resultsToArray()

        return NavigationViewChild {
            Group {
                if data.isEmpty {
                    PlaceholderView(
                        string: placeHolderEmptyText(),
                        imageString: viewModel.showElapsedDoses
                            ? DosesView.historyIcon
                            : DosesView.historyIcon)
                } else {
                    List {
                        ForEach(data, id: \.self) { (section: [Dose]) in
                            Section(header: Text(section[0].doseFormattedMYTakenDate)) {
                                self.rowsView(section: section)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .toasted(show: $presentableToast.show, message: $presentableToast.message)
            .navigationTitle(navigationTitle().rawValue)
            .navigationBarAccessibilityIdentifier(navigationTitle())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.medsCount > 0 {
                        HStack {
                            Text("")
                                .accessibilityHidden(true)

                            Button(action: {
                                navigation.pushView(
                                    DoseAddView(
                                        med: viewModel.createMed()))
                            }, label: {
                                // INFO: In iOS 14.3 VoiceOver has a glitch that reads the label
                                // "Add Dose" as "Add" no matter what accessibility label
                                // we give this toolbar button when using a label.
                                // As a result, when VoiceOver is running, we use a text
                                // view for the button instead, forcing a correct reading
                                // without losing the original layout.
                                if UIAccessibility.isVoiceOverRunning {
                                    Text(.doseEditAddDose)
                                        .accessibilityIdentifier(.doseEditAddDose)

                                } else {
                                    Label(.doseEditAddDose, systemImage: SFSymbol.plus.systemName)
                                        .accessibilityElement()
                                        .accessibility(addTraits: .isButton)
                                        .accessibilityIdentifier(.doseEditAddDose)
                                }
                            })
                        }
                    }
                }
            }

            PlaceholderView(
                string: placeHolderText(),
                imageString: viewModel.showElapsedDoses
                    ? DosesView.historyIcon
                    : DosesView.historyIcon)
        }
        .onAppear(perform: {
            self.tabBarHandler.showTabBar()
        })
    }

    func placeHolderText() -> Strings {
        viewModel.medsCount > 0
            ? .commonPleaseSelect
            : .commonPleaseAdd
    }

    func navigationTitle() -> Strings {
        viewModel.showElapsedDoses
            ? .tabTitleHistory
            : .tabTitleInProgress
    }

    func placeHolderEmptyText() -> Strings {
        viewModel.medsCount > 0
            ? .commonEmptyView
            : .commonPleaseAdd
    }

    init(dataController: DataController, showElapsedDoses: Bool) {
        let viewModel = ViewModel(dataController: dataController, showElapsedDoses: showElapsedDoses)

        _viewModel = StateObject(wrappedValue: viewModel)
    }
}

struct DosesView_Previews: PreviewProvider {
    static var previews: some View {
        DosesView(dataController: DataController.preview, showElapsedDoses: false)
    }
}
