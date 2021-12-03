//
//  MedEditView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// This view is shown via the MedicationView to allow editing of medication

import SwiftUI

struct MedEditView: View {
    let med: Med

    @EnvironmentObject var dataController: DataController
    
    let types = ["mg", "ml", "Tspn"]

    
    @State private var defaultTitle: String
    @State private var defaultAmount: String
    @State private var dosage: String
    @State private var measure: String
    @State private var form: String
    @State private var notes: String
    @State private var remaining: Int
    @State private var sequence: Int
    
    init(med: Med) {
        self.med = med
        
        _defaultTitle = State(wrappedValue: med.medDefaultTitle)
        _defaultAmount = State(wrappedValue: med.medDefaultAmount)
        _dosage = State(wrappedValue: med.medDosage)
        _measure = State(wrappedValue: med.medMeasure)
        _form = State(wrappedValue: med.medForm)
        _notes = State(wrappedValue: med.medNotes)
        _remaining = State(wrappedValue: Int(med.remaining))
        _sequence = State(wrappedValue: Int(med.sequence))
    }
    
    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                TextField("Default Text", text: $defaultTitle.onChange(update))
                
                TextField("Default Amount", text: $defaultAmount.onChange(update))
                    .keyboardType(.decimalPad)
                
                TextField("Dosage", text: $dosage.onChange(update))
                    .keyboardType(.decimalPad)
                
                Picker("Measure", selection: $measure.onChange(update)) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Form", text: $form.onChange(update))

                TextField("Remaining", value: $remaining.onChange(update), formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                
                TextField("Sequence", value: $sequence.onChange(update), formatter: NumberFormatter())
                    .keyboardType(.numberPad)
            }
            
            Section(header: Text("Example")) {
                Text(med.medDisplay)
            }
            
            Section(header: Text("Notes")) {
                TextField("", text: $notes.onChange(update))
                    .lineLimit(nil)
            }

        }
        .navigationTitle("Edit Med")
        .onDisappear(perform: dataController.save)
    }
    
    func update() {
        med.dose?.objectWillChange.send()
        
        med.defaultTitle = defaultTitle
        med.defaultAmount = NSDecimalNumber(string: defaultAmount)
        med.dosage = NSDecimalNumber(string: dosage)
        med.measure = measure
        med.form = form
        med.notes = notes
        med.remaining = Int16(remaining)
        med.sequence = Int16(sequence)
    }
}

struct MedEditView_Previews: PreviewProvider {
    static var previews: some View {
        MedEditView(med: Med.example)
    }
}
