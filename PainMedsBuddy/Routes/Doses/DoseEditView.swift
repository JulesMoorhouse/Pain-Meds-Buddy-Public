//
//  DoseEditView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// INFO: This view allows editing of the dose and selection / re-selection of a med

import CoreData
import SwiftUI

struct DoseEditView: View {
    @StateObject private var viewModel: ViewModel

    @SceneStorage("defaultRemindMe") var defaultRemindMe: Bool = true

    @EnvironmentObject private var dataController: DataController
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var presentableToast: PresentableToastModel

    @State private var isSaveDisabled = false
    @State private var navigationButtonId = UUID()

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
                        .accessibilityLabel(.commonCancel)
                        .accessibilityIdentifier(.commonCancel)
                })
            }
            .id(self.navigationButtonId) // NOTE: Force new instance creation
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

                        if viewModel.selectedMed.medIsRunningLow {
                            let message = String(.medEditLowToast, values: [viewModel.selectedMed.medTitle])
                            self.presentableToast.data
                                = ToastModel(
                                    type: .info,
                                    message: message
                                )
                            self.presentableToast.show = true
                        }
                    }
                }, label: {
                    Text(viewModel.add ? .commonAdd : .commonSave)
                        .accessibilityElement()
                        .accessibility(addTraits: .isButton)
                        .accessibilityLabel(.commonSave)
                        .accessibilityIdentifier(.commonSave)
                })
            }
            .id(self.navigationButtonId) // NOTE: Force new instance creation
        }
    }

    var body: some View {
        NavigationViewChild {
            ZStack {
                Form {
                    Section(header: Text(.commonBasicSettings)) {
                        // --- Time Taken ---
                        DatePicker(
                            .doseEditDateTime,
                            selection: $viewModel.takenDate,
                            displayedComponents: [.hourAndMinute, .date]
                        )
                        .foregroundColor(.secondary)
                        .accessibilityIdentifier(.doseEditDateTime)

                        // --- Medication Select ---
                        NavigationLink(destination:
                            DoseMedSelectView(
                                selectedMed: $viewModel.selectedMed.onChange(viewModel.selectionChanged),
                                dataController: dataController
                            )) { HStack {
                                TwoColumnView(col1: Strings.doseEditMedication.rawValue,
                                              col2: viewModel.selectedMed.medTitle,
                                              hasChevron: false)
                            } }
                            .accessibilityIdentifier(.doseEditMedication)

                        // --- Amount ---
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
                                .foregroundColor(.primary)

                            Text(viewModel.selectedMed.medFormPlural)
                                .foregroundColor(.secondary)
                        }
                        .validation(viewModel.amountValidator)

                        // ---  Remind Me ---
                        HStack {
                            Toggle(isOn: $viewModel.remindMe.onChange(remindMeChanged)) {
                                Text(.doseElapsedReminder)
                                    .foregroundColor(.secondary)
                            }

                            // New red triangle
                            if viewModel.hasStartupNotificationError {
                                Spacer()
                                    .frame(width: 5)

                                Button(action: {
                                    viewModel.activePopup = .initialNotificationError
                                    viewModel.showPopup.toggle()
                                }, label: {
                                    Image(systemName: SFSymbol.exclamationMarkTriangle.systemName)
                                        .foregroundColor(Color.red)
                                })
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                    }

                    // ---  Example Dosage ---
                    Section(header: Text(.commonExampleDosage)) {
                        HStack {
                            MedSymbolView(
                                symbol: viewModel.selectedMed.medSymbol,
                                colour: viewModel.selectedMed.medColor
                            )

                            Text(display())
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                    }

                    // --- Detail notes ---
                    Section(header: Text(.doseEditDetails)) {
                        TextArea(
                            Strings.doseEditDetailsPlaceholder.rawValue,
                            text: $viewModel.details
                        )
                        .frame(minHeight: 50)
                    }

                    if !viewModel.add {
                        // --- Delete Button ---
                        Section {
                            Button(Strings.doseEditDeleteThisDose.rawValue) {
                                viewModel.activeAlert = .deleteConfirmation
                                viewModel.showAlert.toggle()
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .accentColor(.red)
                            .accessibilityIdentifier(.doseEditDeleteThisDose)
                        }

                        // --- Elapse Button ---
                        if !viewModel.elapsed {
                            Section {
                                Button(Strings.doseEditMarkElapsed.rawValue) {
                                    viewModel.activeAlert = .elapseConfirmation
                                    viewModel.showAlert.toggle()
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .accessibilityIdentifier(.doseEditMarkElapsed)
                                .disabled(viewModel.dataChanged)
                            }
                        }
                    }
                }

                if viewModel.showPopup == true {
                    popupOption()
                }
            }
            .navigationBarAccessibilityIdentifier(DoseEditView.navigationTitle(add: viewModel.add))
            .toasted(show: $presentableToast.show, data: $presentableToast.data)
            .alert(isPresented: $viewModel.showAlert) { alertOption() }
            .navigationBarTitle(String(DoseEditView.navigationTitle(add: viewModel.add)), displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                backBarButtonItem
                saveBarButtonItem
            }
        }
        .onRotate { _ in
            self.navigationButtonId = UUID()
        }
        .onReceive(viewModel.formValidation.$allValid) { isValid in
            self.isSaveDisabled = !isValid
        }
        .onReceive(viewModel.formValidation.$validationMessages) { messages in print("Validation: \(messages)") }
        .onAppear(perform: {
            if viewModel.add {
                viewModel.remindMe = defaultRemindMe
            }

            self.viewModel.checkNotificationAbility(startUp: true)
        })
    }

    // MARK: -

    func popupOption() -> some View {
        VStack {
            switch viewModel.activePopup {
            case .initialNotificationError:
                // NOTE: Alert from red triangle icon
                InfoPopupView(
                    showing: $viewModel.showPopup,
                    title: Strings.commonInfo.rawValue,
                    text: Strings.doseEditInitialNotificationsError.rawValue
                )
                .onAppear { UIApplication.endEditing() }
                .onTapGesture { UIApplication.endEditing() }
            }
        }
    }

    func alertOption() -> Alert {
        switch viewModel.activeAlert {
        case .deleteConfirmation:
            return Alert(
                title: Text(.doseEditDeleteDose),
                message: Text(.doseEditAreYouSureDelete),
                primaryButton: .default(Text(.commonDelete),
                                        action: delete),
                secondaryButton: .cancel()
            )
        case .elapseConfirmation:
            return Alert(
                title: Text(.doseEditElapseDose),
                message: Text(.doseEditAreYouSureElapse),
                primaryButton: .default(Text(.commonYes),
                                        action: setElapse),
                secondaryButton: .cancel()
            )
        case .currentNotificationError:
            return Alert(
                title: Text(.doseElapsedReminderAlertTitle),
                message: Text(.doseElapsedReminderAlertMessage),
                primaryButton:
                .default(Text(.doseElapsedReminderAlertButton),
                         action: showAppSettings),
                secondaryButton: .cancel()
            )
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

        let duration = viewModel.selectedMed.medTotalDurationSeconds
        let elapsingDate = viewModel.takenDate.addingTimeInterval(TimeInterval(duration))

        let elapses = String(.doseEditDosageElapsed, values: [elapsingDate.dateToShortDateTime])

        let doseFull = Dose.displayFull(
            amount: "\(amt)",
            dosage: "\(dsg)",
            totalDosage: "\(temp)",
            measure: viewModel.selectedMed.measure ?? "\(MedDefault.measure)",
            form: viewModel.selectedMed.form ?? MedDefault.form
        )

        return "\(doseFull)\n\(elapses)"
    }

    func setElapse() {
        viewModel.setElapsed()
        presentationMode.wrappedValue.dismiss()
    }

    func delete() {
        viewModel.delete()
        presentationMode.wrappedValue.dismiss()
    }

    func remindMeChanged() {
        viewModel.checkNotificationAbility()
    }

    func showAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }

    init(dataController: DataController,
         dose: Dose)
    {
        let viewModel = ViewModel(dataController: dataController, dose: dose)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    init(dataController: DataController,
         selectedMed: Med)
    {
        let viewModel = ViewModel(
            dataController: dataController,
            selectedMed: selectedMed
        )
        _viewModel = StateObject(wrappedValue: viewModel)
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
