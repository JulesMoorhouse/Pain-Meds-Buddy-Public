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

    @EnvironmentObject var dataController: DataController
    @FetchRequest private var meds: FetchedResults<Med>

    @State private var selectedMed = Med()
    @State private var title: String
    @State private var amount: Decimal
    @State private var color: String
    @State private var gapPeriod: Decimal
    @State private var taken: Bool
    @State private var takenDate: Date

    init(dataController: DataController, dose: Dose) {
        self.dose = dose

        _title = State(wrappedValue: dose.doseTitle)
        _amount = State(wrappedValue: dose.doseAmount)
        _color = State(wrappedValue: dose.doseColor)
        _gapPeriod = State(wrappedValue: dose.doseGapPeriod)
        _taken = State(wrappedValue: dose.doseTaken)
        _takenDate = State(wrappedValue: dose.doseTakenDate)

        let fetchRequest: NSFetchRequest<Med> = Med.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Med.sequence, ascending: false)
        ]

        self._meds = FetchRequest(fetchRequest: fetchRequest)

        if let currentMed = dose.med {
            self._selectedMed = State(initialValue: currentMed)

        } else {
            do {
                let tempMeds = try dataController.container.viewContext.fetch(fetchRequest)
                if tempMeds.count > 0 {
                    self._selectedMed = State(initialValue: tempMeds.first!)

                } else {
                    self._selectedMed = State(initialValue: Med(context: dataController.container.viewContext))
                    dataController.container.viewContext.delete(selectedMed)
                }
            } catch {
                fatalError("Error loading data")
            }
        }
    }

    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                DatePicker("Date Time", selection: $takenDate)

                NavigationLink(destination:
                    DoseMedSelectView(meds: meds,
                                  selectedMed: $selectedMed.onChange(update)),
                    label: {
                        HStack {
                            TwoColumnView(col1: "Medication",
                                          col2: selectedMed.medDefaultTitle)
                        }
                    })
            }
            .navigationTitle("Edit Dose")
            .onDisappear(perform: dataController.save)
        }
    }

    func update() {
        dose.objectWillChange.send()

        dose.title = title
        dose.amount = NSDecimalNumber(decimal: amount)
        dose.color = color
        dose.gapPeriod = NSDecimalNumber(decimal: gapPeriod)
        dose.med = selectedMed
        dose.taken = taken
        dose.takenDate = takenDate
    }
}

struct DoseEditView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        DoseEditView(dataController: dataController, dose: Dose.example)
            .environmentObject(dataController)
    }
}
