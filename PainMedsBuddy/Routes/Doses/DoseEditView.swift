//
//  DoseEditView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// INFO: This view allows editing of the dose and selection / re-selection of a med

import CoreData
import SwiftUI
import XNavigation

struct DoseEditView: View, DestinationView {
    var navigationBarTitleConfiguration: NavigationBarTitleConfiguration

    @StateObject var viewModel: ViewModel

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var navigation: Navigation

    @State private var showingDeleteConfirm = false

    var body: some View {
        Form {
            Section(header: Text(.commonBasicSettings)) {
                DatePicker(.doseEditDateTime, selection: $viewModel.takenDate.onChange(viewModel.update))
                    .foregroundColor(.secondary)
                    .accessibilityIdentifier(.doseEditDateTime)

                Button(action: {
                    navigation.pushView(
                        DoseMedSelectView(
                            selectedMed: $viewModel.selectedMed.onChange(viewModel.selectionChanged),
                            dataController: dataController
                        ),
                        animated: true
                    )
                }, label: {
                    HStack {
                        TwoColumnView(col1: Strings.doseEditMedication.rawValue,
                                      col2: viewModel.selectedMed.medTitle,
                                      hasChevron: true)
                    }
                })
                    .accessibilityIdentifier(.doseEditMedication)

                HStack {
                    Text(.doseEditAmount)
                        .foregroundColor(.secondary)
                    Spacer()

                    TextField(String(.commonEgNum,
                                     values: [DoseDefault.Sensible.doseAmount()]),
                              text: $viewModel.amount.onChange(viewModel.update))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .accessibilityIdentifier(.doseEditAmount)

                    Text(viewModel.selectedMed.medForm)
                        .foregroundColor(.secondary)
                }
            }

            Section(header: Text(.commonDosage)) {
                HStack {
                    Spacer()
                    Text(display())
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.trailing)
                }
            }
            if !viewModel.add {
                Section {
                    Button(Strings.doseEditDeleteThisDose.rawValue) {
                        showingDeleteConfirm.toggle()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .accentColor(.red)
                }
            }
        }
        .navigationBarTitle(configuration: navigationBarTitleConfiguration)
        .navigationBarAccessibilityIdentifier(DoseEditView.navigationTitle(add: viewModel.add))
        .onDisappear(perform: viewModel.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(title: Text(.doseEditDeleteDose),
                  message: Text(.doseEditAreYouSure),
                  primaryButton: .default(Text(.commonDelete), action: delete),
                  secondaryButton: .cancel())
        }
    }

    static func navigationTitle(add: Bool) -> Strings {
        add
            ? Strings.doseEditAddDose
            : Strings.doseEditEditDose
    }

    func display() -> String {
        let amt = Decimal(string: viewModel.amount) ?? 0.0
        let dsg = Decimal(string: viewModel.selectedMed.medDosage) ?? 0.0
        let temp = (amt * dsg)

        return Dose.displayFull(amount: "\(amt)",
                                dosage: "\(dsg)",
                                totalDosage: "\(temp)",
                                measure: viewModel.selectedMed.measure ?? "\(MedDefault.measure)",
                                form: viewModel.selectedMed.form ?? MedDefault.form)
    }

    func delete() {
        viewModel.delete()
        presentationMode.wrappedValue.dismiss()
    }

    init(dataController: DataController, dose: Dose, add: Bool) {
        let viewModel = ViewModel(dataController: dataController, dose: dose, add: add)
        _viewModel = StateObject(wrappedValue: viewModel)

        let title = String(DoseEditView.navigationTitle(add: add))

        navigationBarTitleConfiguration = NavigationBarTitleConfiguration(
            title: title,
            displayMode: .automatic
        )
    }
}

struct DoseEditView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        DoseEditView(dataController: dataController, dose: Dose.example, add: false)
            .environmentObject(dataController)
    }
}
