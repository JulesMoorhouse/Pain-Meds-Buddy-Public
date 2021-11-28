//
//  MedicationRowView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct MedicationRowView: View {
    @ObservedObject var medication: Medication

    var body: some View {
        NavigationLink(destination: EditMedicationView(medication: medication)) {
            Text(medication.medicationTitle)
        }
    }
}

struct MedicationRowView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationRowView(medication: Medication.example)
    }
}
