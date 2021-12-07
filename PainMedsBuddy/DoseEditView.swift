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
    let dose: Dose
    let add: Bool
    let meds: [Med]

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @State private var selectedMed: Med
    @State private var title: String
    @State private var amount: String
    @State private var gapPeriod: String
    @State private var taken: Bool
    @State private var takenDate: Date
    @State private var showingDeleteConfirm = false

    init(dataController: DataController, meds: [Med], dose: Dose, add: Bool) {
        self.dose = dose
        self.add = add
        self.meds = meds

        _title = State(wrappedValue: dose.doseTitle)
        _amount = State(wrappedValue: dose.doseAmount)
        _gapPeriod = State(wrappedValue: dose.doseGapPeriod)
        _taken = State(wrappedValue: dose.doseTaken)
        _takenDate = State(wrappedValue: dose.doseTakenDate)

        if meds.count > 0 {
            if let currentMed = dose.med {
                _selectedMed = State(wrappedValue: currentMed)
                initSelection(med: currentMed)
                return
            }

            if let first = meds.first {
                _selectedMed = State(wrappedValue: first)
                initSelection(med: first)
                return
            }
        }
        
        _selectedMed = State(wrappedValue: Med(context: dataController.container.viewContext))
    }

    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                DatePicker("Date Time", selection: $takenDate)
                    .foregroundColor(.secondary)

                NavigationLink(destination:
                    DoseMedSelectView(meds: meds,
                                      selectedMed: $selectedMed.onChange(selectionChanged)),
                    label: {
                        HStack {
                            TwoColumnView(col1: "Medication",
                                          col2: title)
                        }

                    })

                HStack {
                    Text("Amount")
                        .foregroundColor(.secondary)
                    Spacer()
                    TextField("1", text: $amount.onChange(update))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                    Text(selectedMed.medForm)
                }
            }

            Section(header: Text("Dosage")) {
                HStack {
                    Spacer()
                    Text(display())
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.trailing)
                }
            }
            Section {
                Button($taken.wrappedValue ? "Missed this dose" : "Taken dose") {
                    $taken.wrappedValue.toggle()
                }

                Button("Delete this Dose") {
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
            }
        }
        .navigationTitle(add ? "Add Dose" : "Edit Dose")
        .onDisappear(perform: save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(title: Text("Delete dose?"),
                  message: Text("Are you sure you want to delete this does?"),
                  primaryButton: .default(Text("Delete"), action: delete),
                  secondaryButton: .cancel())
        }
    }

    mutating func initSelection(med: Med) {
        if add {
            _amount = State(wrappedValue: med.medDefaultAmount)
        }
    }

    func display() -> String {
        let amt = Decimal(string: amount) ?? 0.0
        let dsg = Decimal(string: selectedMed.medDosage) ?? 0.0
        let temp = (amt * dsg)

        return Dose.displayFull(amount: amount,
                                dosage: selectedMed.medDosage,
                                totalDosage: "\(temp)",
                                measure: selectedMed.measure ?? "",
                                form: selectedMed.form ?? "")
    }

    func selectionChanged() {
        let med = selectedMed

        dose.title = med.defaultTitle
        dose.amount = med.defaultAmount

        title = med.medDefaultTitle
        amount = "\(med.medDefaultAmount)"

        dose.med = med

        update()
    }

    func update() {
        dose.objectWillChange.send()

        dose.amount = NSDecimalNumber(string: amount)
        dose.gapPeriod = NSDecimalNumber(string: gapPeriod)
        dose.taken = taken
        dose.takenDate = takenDate
    }

    func delete() {
        dataController.delete(dose)
        presentationMode.wrappedValue.dismiss()
    }

    func save() {
        dose.med = selectedMed
        dataController.save()
    }
}

struct DoseEditView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        DoseEditView(dataController: dataController,  meds: [Med()], dose: Dose.example, add: false)
            .environmentObject(dataController)
    }
}
