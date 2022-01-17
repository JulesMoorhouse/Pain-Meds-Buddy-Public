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
    @State private var isSaveDisabled = false

    var backBarButtonItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            HStack {
                Text("")
                    .accessibilityHidden(true)

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text(.commonCancel)
                        .accessibilityElement()
                        .accessibility(addTraits: .isButton)
                        .accessibilityIdentifier(.commonCancel)
                })
            }
        }
    }

    var saveBarButtonItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack {
                Text("")
                    .accessibilityHidden(true)

                Button(action: {
                    let valid = viewModel.formValidation.triggerValidation()
                    if valid {
                        viewModel.save()
                        presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Text(.commonSave)
                        .accessibilityElement()
                        .accessibility(addTraits: .isButton)
                        .accessibilityIdentifier(.commonSave)
                })
            }
        }
    }

    var body: some View {
        Form {
            Section(header: Text(.commonBasicSettings)) {
                DatePicker(
                    .doseEditDateTime,
                    selection: $viewModel.takenDate,
                    displayedComponents: [.hourAndMinute, .date]
                )
                .foregroundColor(.secondary)
                .accessibilityIdentifier(.doseEditDateTime)

                Button(action: {
                    UIApplication.endEditing()
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

                    TextField(String(.commonEgString,
                                     values: [DoseDefault.Sensible.doseAmount()]),
                              text: $viewModel.amount)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .accessibilityIdentifier(.doseEditAmount)
                        .textFieldStyle(SelectAllTextFieldStyle())

                    Text(viewModel.selectedMed.medForm)
                        .foregroundColor(.secondary)
                }
                .validation(viewModel.amountValidator)

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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            backBarButtonItem
            saveBarButtonItem
        }
        .onReceive(viewModel.formValidation.$allValid) { isValid in
            self.isSaveDisabled = !isValid
        }
        .onReceive(viewModel.formValidation.$validationMessages) { messages in print("Validation: \(messages)") }
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

    init(dataController: DataController,
         dose: Dose)
    {
        let viewModel = ViewModel(dataController: dataController, dose: dose)
        _viewModel = StateObject(wrappedValue: viewModel)

        let title = String(DoseEditView.navigationTitle(add: false))

        navigationBarTitleConfiguration = NavigationBarTitleConfiguration(
            title: title,
            displayMode: .automatic
        )
    }

    init(dataController: DataController,
         selectedMed: Med)
    {
        let viewModel = ViewModel(dataController: dataController, selectedMed: selectedMed)
        _viewModel = StateObject(wrappedValue: viewModel)

        let title = String(DoseEditView.navigationTitle(add: true))

        navigationBarTitleConfiguration = NavigationBarTitleConfiguration(
            title: title,
            displayMode: .automatic
        )
    }
}

struct DoseEditView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        DoseEditView(
            dataController: dataController,
            dose: Dose.example
        )
        .environmentObject(dataController)
    }
}
