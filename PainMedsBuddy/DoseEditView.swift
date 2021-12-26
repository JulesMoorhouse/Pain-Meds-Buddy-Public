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

    let dose: Dose
    let add: Bool

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var navigation: Navigation

    @FetchRequest private var meds: FetchedResults<Med>

    @State private var selectedMed: Med
    @State private var amount: String
    @State private var takenDate: Date
    @State private var showingDeleteConfirm = false

    init(dataController: DataController, dose: Dose, add: Bool) {
        self.dose = dose
        self.add = add

        let title = String(DoseEditView.navigationTitle(add: add))

        self.navigationBarTitleConfiguration = NavigationBarTitleConfiguration(
            title: title,
            displayMode: .automatic
        )

        _amount = State(wrappedValue: dose.doseAmount)
        _takenDate = State(wrappedValue: dose.doseTakenDate)

        let fetchRequest = NSFetchRequest<Med>(entityName: "Med")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Med.sequence, ascending: false)
        ]

        _meds = FetchRequest(fetchRequest: fetchRequest)

        if let currentMed = dose.med {
            _selectedMed = State(wrappedValue: currentMed)
            initSelection(med: currentMed)
            return
        }

        _selectedMed = State(wrappedValue: Med(context: dataController.container.viewContext))
    }

    var body: some View {
        Form {
            Section(header: Text(.commonBasicSettings)) {
                DatePicker(.doseEditDateTime, selection: $takenDate)
                    .foregroundColor(.secondary)

                Button(action: {
                    navigation.pushView(
                        DoseMedSelectView(selectedMed: $selectedMed.onChange(selectionChanged)),
                        animated: true
                    )
                }, label: {
                    HStack {
                        TwoColumnView(col1: Strings.commonMedication.rawValue,
                                      col2: selectedMed.medTitle,
                                      hasChevron: true)
                    }
                })

                HStack {
                    Text(.doseEditAmount)
                        .foregroundColor(.secondary)
                    Spacer()

                    TextField(String(.commonEgNum,
                                     values: [DoseDefault.Sensible.doseAmount()]),
                              text: $amount.onChange(update))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                    Text(selectedMed.medForm)
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
            if !add {
                Section {
                    Button(Strings.doseEditDeleteThisDose.rawValue) {
                        showingDeleteConfirm.toggle()
                    }
                    .accentColor(.red)
                }
            }
        }
        .navigationBarTitle(configuration: navigationBarTitleConfiguration)
        .onDisappear(perform: save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(title: Text(.doseEditDeleteDose),
                  message: Text(.doseEditAreYouSure),
                  primaryButton: .default(Text(.commonDelete), action: delete),
                  secondaryButton: .cancel())
        }
    }

    mutating func initSelection(med: Med) {
        if add {
            _amount = State(wrappedValue: med.medDefaultAmount)
        }
    }

    static func navigationTitle(add: Bool) -> Strings {
        add
            ? Strings.doseEditAddDose
            : Strings.doseEditEditDose
    }

    func display() -> String {
        let amt = Decimal(string: amount) ?? 0.0
        let dsg = Decimal(string: selectedMed.medDosage) ?? 0.0
        let temp = (amt * dsg)

        return Dose.displayFull(amount: "\(amt)",
                                dosage: "\(dsg)",
                                totalDosage: "\(temp)",
                                measure: selectedMed.measure ?? "\(MedDefault.measure)",
                                form: selectedMed.form ?? MedDefault.form)
    }

    func selectionChanged() {
        let med = selectedMed

        dose.amount = med.defaultAmount

        amount = "\(med.medDefaultAmount)"

        if dose.med != med {
            dose.med = med
        }

        update()
    }

    func update() {
        dose.objectWillChange.send()

        dose.amount = NSDecimalNumber(string: amount)
        dose.takenDate = takenDate
    }

    func delete() {
        dataController.delete(dose)
        presentationMode.wrappedValue.dismiss()
    }

    func save() {
        if dose.med != selectedMed {
            dose.med = selectedMed
        }
        dose.med?.lastTakenDate = takenDate
        dose.med?.remaining -= Int16(amount) ?? 0
        dataController.save()
        dataController.container.viewContext.processPendingChanges()
    }
}

struct DoseEditView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        DoseEditView(dataController: dataController, dose: Dose.example, add: false)
            .environmentObject(dataController)
    }
}
