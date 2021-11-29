//
//  DoseRowView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// This view is a row used on the DoseView

import SwiftUI

struct DoseRowView: View {
    @ObservedObject var dose: Dose

    var body: some View {
        NavigationLink(destination:
            EditDoseView(dose: dose)) {
                Text(dose.doseTitle)
        }
    }
}

struct DoseRowView_Previews: PreviewProvider {
    static var previews: some View {
        DoseRowView(dose: Dose.example)
    }
}
