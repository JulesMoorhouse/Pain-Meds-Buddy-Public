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
    @State private var defaultAmount: Decimal
    @State private var dosage: Decimal
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
                
                TextField("Default Amount", value: $defaultAmount.onChange(update), formatter: NumberFormatter())
                
                TextField("Dosage", value: $dosage.onChange(update), formatter: NumberFormatter())
                
                Picker("Measure", selection: $measure.onChange(update)) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Form", text: $form.onChange(update))

                TextField("Remaining", value: $remaining.onChange(update), formatter: NumberFormatter())
                
                TextField("Sequence", value: $sequence.onChange(update), formatter: NumberFormatter())
            }
            
//            Section(header: Text("Example")) {
//                Text(display())
//            }
            
            Section(header: Text("Notes")) {
                TextField("", text: $notes.onChange(update))
                    .lineLimit(nil)
            }

        }
        .navigationTitle("Edit Med")
        .onDisappear(perform: dataController.save)
    }
    
//    func display() -> String {
//        "\(NSDecimalNumber(decimal:defaultAmount).stringValue) x \(NSDecimalNumber(decimal: dosage).stringValue) \(measure) \(form)"
//    }
    
    func update() {
        med.dose?.objectWillChange.send()
        
        med.defaultTitle = defaultTitle
        med.defaultAmount = NSDecimalNumber(decimal: defaultAmount)
        med.dosage = NSDecimalNumber(decimal: dosage)
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
