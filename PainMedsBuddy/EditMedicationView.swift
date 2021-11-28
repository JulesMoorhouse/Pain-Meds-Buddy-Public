//
//  EditMedsView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct EditMedsView: View {
    let med: Med

    @EnvironmentObject var dataController: DataController
    
    @State private var defaultTitle: String
    @State private var defaultUnit: String
    @State private var defaultAmount: Decimal
    @State private var notes: String
    @State private var remaining: Int
    @State private var sequence: Int

    init(med: Med) {
        self.med = med
        
        _defaultTitle = State(wrappedValue: med.medDefaultTitle)
        _defaultUnit = State(wrappedValue: med.medDefaultUnit)
        _defaultAmount = State(wrappedValue: med.medDefaultAmount)
        _notes = State(wrappedValue: med.medNotes)
        _remaining = State(wrappedValue: Int(med.remaining))
        _sequence = State(wrappedValue: Int(med.sequence))
    }
    
    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                TextField("Med name", text: $defaultTitle)
                TextField("Description", text: $defaultUnit)

            }
            
            Section {
                Picker("Sequence", selection: $sequence) {
                    ForEach(1 ..< 100) {
                        Text("\($0)")
                    }
                }
            }
        }
        .navigationTitle("Edit Med")
        .onDisappear(perform: update)
    }
    
    func update() {
        med.dose?.objectWillChange.send()
        
        med.defaultTitle = defaultTitle
        med.defaultUnit = defaultUnit
        med.defaultAmount = NSDecimalNumber(decimal: defaultAmount)
        med.notes = notes
        med.remaining = Int16(remaining)
        med.sequence = Int16(sequence)
    }
}

struct EditMedsView_Previews: PreviewProvider {
    static var previews: some View {
        EditMedsView(med: Med.example)
    }
}
