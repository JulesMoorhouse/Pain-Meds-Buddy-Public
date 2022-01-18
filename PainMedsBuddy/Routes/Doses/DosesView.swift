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
    static let historyTag: String? = "History"

    @StateObject private var viewModel: ViewModel
    @EnvironmentObject var navigation: Navigation

    @State private var showToast: Bool = false
    @EnvironmentObject private var presentableToast: PresentableToast

    private let toastOptions = SimpleToastOptions(
        alignment: .bottom,
        hideAfter: 5,
        showBackdrop: false)

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

        return NavigationView {
            Group {
                if data.isEmpty {
                    PlaceholderView(string: placeHolderEmptyText(),
                                    imageString: SFSymbol.pills.systemName)
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
            .simpleToast(isPresented: $presentableToast.show, options: toastOptions) {
                HStack {
                    Image(systemName: SFSymbol.exclamationMarkTriangle.systemName)
                    Text(String(.medEditLowToast, values: [presentableToast.med.medTitle]))
                        .font(.caption)
                }
                .padding()
                .background(Color.blue.opacity(0.8))
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .padding(.vertical, 5)
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

            PlaceholderView(string: placeHolderText(),
                            imageString: SFSymbol.eyeDropperHalfFull.systemName)
        }
        .iPadOnlyStackNavigationView()
        .navigationBarHidden(true)
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
