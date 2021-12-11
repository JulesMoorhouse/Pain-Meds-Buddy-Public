//
//  MedEditView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// INFO: This view is shown via the MedicationView to allow editing of medication

import SwiftUI

struct MedEditView: View {
    let med: Med
    let add: Bool

    @EnvironmentObject var dataController: DataController
    
    @State private var title: String
    @State private var defaultAmount: String
    @State private var color: String
    @State private var symbol: String
    @State private var dosage: String
    @State private var measure: String
    @State private var form: String
    @State private var notes: String
    @State private var remaining: String
    @State private var sequence: String
    
    let types = ["mg", "ml", "Tspn"]

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]
    
    init(med: Med, add: Bool) {
        self.med = med
        self.add = add
        
        _title = State(wrappedValue: med.medTitle)
        _defaultAmount = State(wrappedValue: med.medDefaultAmount)
        _color = State(wrappedValue: med.medColor)
        _symbol = State(wrappedValue: med.medSymbol)
        _dosage = State(wrappedValue: med.medDosage)
        _measure = State(wrappedValue: med.medMeasure)
        _form = State(wrappedValue: med.medForm)
        _notes = State(wrappedValue: med.medNotes)
        _remaining = State(wrappedValue: med.medRemaining)
        _sequence = State(wrappedValue: med.medSequence)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                TextField("Default Text", text: $title.onChange(update))
                
                HStack {
                    Text("Default Amount")
                        .foregroundColor(.secondary)
                    Spacer()
                    TextField("1", text: $defaultAmount.onChange(update))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                    Text(med.medForm)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Dosage")
                        .foregroundColor(.secondary)
                    Spacer()
                    TextField("300", text: $dosage.onChange(update))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                    Text(med.medMeasure)
                        .foregroundColor(.secondary)
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
                    TextField("84", text: $remaining.onChange(update))
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                    Text(med.medForm)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Sequence")
                        .foregroundColor(.secondary)
                    Spacer()
                    TextField("1", text: $sequence.onChange(update))
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
            
            Section(header: Text("Symbol")) {
                Text("Colour")
                LazyVGrid(columns: colorColumns) {
                    ForEach(Med.colors, id: \.self) { item in
                        ZStack {
                            Color(item)
                                .aspectRatio(1, contentMode: .fit)
                                .cornerRadius(6)
                            
                            if item == color {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                            }
                        }
                        .onTapGesture {
                            color = item
                            update()
                        }
                    }
                }
                .padding(.vertical)
                
                Text("Image")
                SymbolsView(colour: Color($color.wrappedValue), selectedSymbol: $symbol.onChange(update))
                    .padding(.vertical)
            }
            
            Section(header: Text("Notes")) {
                TextEditor(text: $notes.onChange(update))
            }

        }
        .navigationTitle(add ? "Add Med" : "Edit Med")
        .onDisappear(perform: dataController.save)
    }
    
    func update() {
        med.dose?.objectWillChange.send()

        med.title = title
        med.defaultAmount = NSDecimalNumber(string: defaultAmount)
        med.color = color
        med.symbol = symbol
        med.dosage = NSDecimalNumber(string: dosage)
        med.measure = measure
        med.form = form
        med.notes = notes
        med.remaining = Int16(remaining) ?? MedDefault.remaining
        med.sequence = Int16(sequence) ?? MedDefault.sequence
    }
}

struct MedEditView_Previews: PreviewProvider {
    static var previews: some View {
        MedEditView(med: Med.example, add: false)
    }
}
