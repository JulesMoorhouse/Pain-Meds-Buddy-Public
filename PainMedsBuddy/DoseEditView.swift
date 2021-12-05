//
//  DoseEditView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// This view allows editing of the dose and selection / re-selection of a med

import CoreData
import SwiftUI

struct DoseEditView: View {
    let dose: Dose
    let add: Bool

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest private var meds: FetchedResults<Med>

    @State private var selectedMed = Med()
    @State private var title: String
    @State private var amount: String
    @State private var gapPeriod: String
    @State private var taken: Bool
    @State private var takenDate: Date
    @State private var showingDeleteConfirm = false

    init(dataController: DataController, dose: Dose, add: Bool) {
        self.dose = dose
        self.add = add

        _title = State(wrappedValue: dose.doseTitle)
        _amount = State(wrappedValue: dose.doseAmount)
        _gapPeriod = State(wrappedValue: dose.doseGapPeriod)
        _taken = State(wrappedValue: dose.doseTaken)
        _takenDate = State(wrappedValue: dose.doseTakenDate)

        let fetchRequest: NSFetchRequest<Med> = Med.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Med.creationDate, ascending: false)
        ]

        self._meds = FetchRequest(fetchRequest: fetchRequest)

        do {
            var found = false
            let tempMeds = try dataController.container.viewContext.fetch(fetchRequest)
            if tempMeds.count > 0 {
                if let currentMed = dose.med {
                    initSelection(med: currentMed)
                    found = true
                }

                if !found {
                    if let first = tempMeds.first {
                        initSelection(med: first)
                    }
                }
            }
        } catch {
            fatalError("Error loading data")
        }
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
        _selectedMed = State(wrappedValue: med)
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
        DoseEditView(dataController: dataController, dose: Dose.example, add: false)
            .environmentObject(dataController)
    }
}
