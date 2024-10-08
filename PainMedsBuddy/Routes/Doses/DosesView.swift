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

struct DosesView: View {
    static let inProgressTag: String? = "InProgress"
    static let inProgressIcon: String
        = SFSymbol.timer.systemName

    static let historyTag: String? = "History"
    static let historyIcon: String
        = SFSymbol.booksVerticalFill.systemName

    @StateObject private var viewModel: ViewModel
    @EnvironmentObject private var presentableToast: PresentableToastModel

    @State private var showSheet = false
    @State private var navigationButtonId = UUID()

    var body: some View {
        let data: [[Dose]] = viewModel.resultsToArray()

        return NavigationViewChild {
            Group {
                Group {
                    if data.isEmpty {
                        PlaceholderView(
                            string: placeHolderEmptyText(),
                            imageString: viewModel.showElapsedDoses
                                ? DosesView.historyIcon
                                : DosesView.inProgressIcon
                        )
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
                .sheet(isPresented: $showSheet) {
                    DoseAddView(
                        med: viewModel.createMed())
                        .allowAutoDismiss(false)
                        .onDisappear {
                            // NOTE: Update button id after sheet got closed
                            self.navigationButtonId = UUID()
                        }
                }
                .navigationTitle(navigationTitle().rawValue)
                .navigationBarAccessibilityIdentifier(navigationTitle())
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if viewModel.medsCount > 0 {
                            HStack {
                                Text("")
                                    .accessibilityHidden(true)

                                Button(action: {
                                    showSheet.toggle()
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
                                            .accessibilityLabel(.doseEditAddDose)
                                            .accessibilityIdentifier(.doseEditAddDose)
                                    }
                                })
                            }
                            .id(self.navigationButtonId) // NOTE: Force new instance creation
                        }
                    }
                }

                PlaceholderView(
                    string: placeHolderText(),
                    imageString: viewModel.showElapsedDoses
                        ? DosesView.historyIcon
                        : DosesView.inProgressIcon
                )
            }
            .toasted(show: $presentableToast.show, data: $presentableToast.data)
        }
    }

    // MARK: -

    func rowsView(section: [Dose]) -> some View {
        ForEach(section, id: \.self) { dose in
            DoseRowView(dose: dose)
        }
        .onDelete { offsets in
            viewModel.deleteDose(offsets, from: section)
        }
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
