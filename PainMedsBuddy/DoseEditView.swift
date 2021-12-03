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
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest private var meds: FetchedResults<Med>

    @State private var selectedMed = Med()
    @State private var title: String
    @State private var amount: String
    @State private var gapPeriod: String
    @State private var taken: Bool
    @State private var takenDate: Date
    @State private var showingDeleteConfirm = false
    
    init(dataController: DataController, dose: Dose) {
        self.dose = dose

        _title = State(wrappedValue: dose.doseTitle)
        _amount = State(wrappedValue: dose.doseAmount)
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
                    .foregroundColor(.secondary)

                NavigationLink(destination:
                    DoseMedSelectView(meds: meds,
                                      selectedMed: $selectedMed.onChange(selectionChanged)),
                    label: {
                        HStack {
                            TwoColumnView(col1: "Medication",
                                          col2: selectedMed.medDefaultTitle)
                        }

                    })

                HStack {
                    Text("Amount")
                        .foregroundColor(.secondary)
                    Spacer()
                    TextField("1", text: $amount.onChange(update))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                    Text(dose.med?.medForm ?? "")
                }
            }
            
            Section(header: Text("Dosage")) {
                HStack {
                    Spacer()
                    Text(dose.doseDisplayFull)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.trailing)
                        //.background(Color.blue)
                }

            }
            Section {
                Button(dose.taken ? "Missed this dose" : "Taken dose") {
                    dose.taken.toggle()
                    update()
                }
                
                Button("Delete this Dose") {
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
            }
        }
        .navigationTitle("Edit Dose")
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(title: Text("Delete dose?"), message: Text("Are you sure you want to delete this does?"), primaryButton: .default(Text("Delete") , action: delete), secondaryButton: .cancel())
        }
    }

    func selectionChanged() {
        
        dose.title = selectedMed.defaultTitle
        dose.amount = selectedMed.defaultAmount
        amount = "\(selectedMed.medDefaultAmount)"
        
        update()
    }
    
    func update() {
        dose.objectWillChange.send()

        dose.amount = NSDecimalNumber(string: amount)
        dose.gapPeriod = NSDecimalNumber(string: gapPeriod)
        dose.med = selectedMed
        dose.taken = taken
        dose.takenDate = takenDate
    }
    
    func delete() {
        dataController.delete(dose)
        presentationMode.wrappedValue.dismiss()
    }
}

struct DoseEditView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        DoseEditView(dataController: dataController, dose: Dose.example)
            .environmentObject(dataController)
    }
}
