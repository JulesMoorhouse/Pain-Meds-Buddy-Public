//
//  DoseMedSelectView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct DoseMedSelectView: View {
    @Environment(\.presentationMode) var presentationMode

    let meds: [Med]
    
    @Binding var selectedMed: Med
    @State private var showingSortOrder = false
    @State private var sortOrder = Med.SortOrder.optimzed
    
    init(meds: [Med], selectedMed: Binding<Med>) {
        self.meds = meds.allMedsDefaultSorted
        _selectedMed = selectedMed
    }

    var body: some View {
        Form {
            ForEach(0 ..< meds.count) { index in
                HStack {
                    MedRowView(med: self.meds[index])

                    Spacer()

                    if self.selectedMed == meds[index] {
                        Image(systemName: "checkmark")
                            .foregroundColor(Color.blue)
                    }
                }
                .contentShape(Rectangle())
                .foregroundColor(.primary)
                .onTapGesture {
                    self.selectedMed = meds[index]
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

 struct DoseMedSelectView_Previews: PreviewProvider {
    static var previews: some View {
        DoseMedSelectView(meds: [Med()], selectedMed: .constant(Med()))
    }
 }
