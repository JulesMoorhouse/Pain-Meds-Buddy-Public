//
//  EditMedicationView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct EditMedicationView: View {
    let medication: Medication

    @EnvironmentObject var dataController: DataController
    
    @State private var title: String
    @State private var detail: String
    @State private var sequence: Int

    init(medication: Medication) {
        self.medication = medication
        
        _title = State(wrappedValue: medication.medicationTitle)
        _detail = State(wrappedValue: medication.medicationDetail)
        _sequence = State(wrappedValue: Int(medication.sequence))
    }
    
    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                TextField("Medication name", text: $title)
                TextField("Description", text: $detail)

            }
            
            Section {
                Picker("Sequence", selection: $sequence) {
                    ForEach(1 ..< 100) {
                        Text("\($0)")
                    }
                }
            }
        }
        .navigationTitle("Edit Medication")
        .onDisappear(perform: update)
    }
    
    func update() {
        medication.dose?.objectWillChange.send()
        
        medication.title = title
        medication.detail = detail
        medication.sequence = Int16(sequence)
    }
}

struct EditMedicationView_Previews: PreviewProvider {
    static var previews: some View {
        EditMedicationView(medication: Medication.example)
    }
}
