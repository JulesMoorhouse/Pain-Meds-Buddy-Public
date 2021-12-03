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
                
                HStack {
                    Text("Default Amount")
                        .foregroundColor(.secondary)
                    Spacer()
                    TextField("1", text: $defaultAmount.onChange(update))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                    Text(med.medForm)
                }
                
                HStack {
                    Text("Dosage")
                        .foregroundColor(.secondary)
                    Spacer()
                    TextField("300", text: $dosage.onChange(update))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                    Text(med.medMeasure)
                }
                
                Picker("Measure", selection: $measure.onChange(update)) {
                    ForEach(types, id: \.self) {
                        Text($0)
                            .foregroundColor(.primary)
                    }
                }
                .foregroundColor(.secondary)
                
                HStack {
                    Text("Form")
                        .foregroundColor(.secondary)
                    Spacer()
                    TextField("Pill", text: $form.onChange(update))
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Text("Remaining")
                        .foregroundColor(.secondary)
                    Spacer()
                    TextField("84", value: $remaining.onChange(update), formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                    Text(med.medForm)
                }
                
                HStack {
                    Text("Sequence")
                        .foregroundColor(.secondary)
                    Spacer()
                    TextField("1", value: $sequence.onChange(update), formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
            }
            
            Section(header: Text("Example Dosage")) {
                HStack {
                    Spacer()
                    Text(med.medDisplay)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.secondary)
                }
            }
            
            Section(header: Text("Notes")) {
                TextEditor(text: $notes.onChange(update))
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
