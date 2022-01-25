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

    @StateObject private var viewModel: ViewModel

    @SceneStorage("defaultRemindMe") var defaultRemindMe: Bool = true

    @EnvironmentObject private var dataController: DataController
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var navigation: Navigation
    @EnvironmentObject private var tabBarHandler: TabBarHandler
    @EnvironmentObject private var presentableToast: PresentableToast

    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .deleteConfirmation
    @State private var isSaveDisabled = false

    enum ActiveAlert {
        case deleteConfirmation, elapseConfirmation
    }

    var backBarButtonItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            HStack {
                Text("")
                    .accessibilityHidden(true)

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    self.tabBarHandler.showTabBar()
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
                        self.tabBarHandler.showTabBar()

                        if viewModel.selectedMed.medIsRunningLow {
                            let message = String(.medEditLowToast, values: [viewModel.selectedMed.medTitle])
                            self.presentableToast.message = message
                            self.presentableToast.show = true
                        }
                    }
                }, label: {
                    Text(viewModel.add ? .commonAdd : .commonSave)
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

                    Text(viewModel.selectedMed.medFormPlural)
                        .foregroundColor(.secondary)
                }
                .validation(viewModel.amountValidator)

                Toggle(isOn: $viewModel.remindMe.onChange(remindMeChanged)) {
                    Text(.doseElapsedReminder)
                        .foregroundColor(.secondary)
                        .alert(isPresented: $viewModel.showingNotificationError) {
                            Alert(
                                title: Text(.doseElapsedReminderAlertTitle),
                                message: Text(.doseElapsedReminderAlertMessage),
                                primaryButton:
                                .default(Text(.doseElapsedReminderAlertButton),
                                         action: showAppSettings),
                                secondaryButton: .cancel()
                            )
                        }
                }
            }

            Section(header: Text(.commonExampleDosage)) {
                HStack {
                    Text(display())
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
            }

            Section(header: Text(.doseEditDetails)) {
                TextArea(
                    Strings.doseEditDetailsPlaceholder.rawValue,
                    text: $viewModel.details
                )
                .frame(minHeight: 50)
            }

            if !viewModel.add {
                Section {
                    Button(Strings.doseEditDeleteThisDose.rawValue) {
                        activeAlert = .deleteConfirmation
                        showAlert.toggle()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .accentColor(.red)
                }

                if !viewModel.elapsed {
                    Section {
                        Button(Strings.doseEditMarkElapsed.rawValue) {
                            activeAlert = .elapseConfirmation
                            showAlert.toggle()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .disabled(viewModel.dataChanged)

                    }
                }
            }
        }
        .navigationBarTitle(configuration: navigationBarTitleConfiguration)
        .navigationBarAccessibilityIdentifier(DoseEditView.navigationTitle(add: viewModel.add))
        .toasted(show: $presentableToast.show, message: $presentableToast.message)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            backBarButtonItem
            saveBarButtonItem
        }
        .onReceive(viewModel.formValidation.$allValid) { isValid in
            self.isSaveDisabled = !isValid
        }
        .onReceive(viewModel.formValidation.$validationMessages) { messages in print("Validation: \(messages)") }
        .alert(isPresented: $showAlert) { alertOption() }
        .onAppear(perform: {
            self.tabBarHandler.hideTabBar()

            viewModel.remindMe = defaultRemindMe

            self.viewModel.checkNotificationAbility()
        })
    }

    func alertOption() -> Alert {
        switch activeAlert {
        case .deleteConfirmation:
            return Alert(title: Text(.doseEditDeleteDose),
                         message: Text(.doseEditAreYouSureDelete),
                         primaryButton: .default(Text(.commonDelete),
                                                 action: delete),
                         secondaryButton: .cancel())
        case .elapseConfirmation:
            return Alert(title: Text(.doseEditElapseDose),
                         message: Text(.doseEditAreYouSureElapse),
                         primaryButton: .default(Text(.commonOK),
                                                 action: setElapse),
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

        let title = String(DoseEditView.navigationTitle(add: false))

        navigationBarTitleConfiguration = NavigationBarTitleConfiguration(
            title: title,
            displayMode: .automatic
        )
    }

    init(dataController: DataController,
         selectedMed: Med)
    {
        let viewModel = ViewModel(
            dataController: dataController,
            selectedMed: selectedMed
        )

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
