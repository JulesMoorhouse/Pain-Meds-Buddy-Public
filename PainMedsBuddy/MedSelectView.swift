//
//  MedSelectView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct MedSelectView: View {
    @Environment(\.presentationMode) var presentationMode

    var meds: FetchedResults<Med>
    @Binding var selectedMed: Med

    var body: some View {
        Form {
            ForEach(0 ..< meds.count) { index in
                HStack {
                    TwoColumnView(col1: self.meds[index].medDefaultTitle,
                                  col2: "\(self.meds[index].remaining) \(self.meds[index].medDefaultUnit)")

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

//struct MedSelectView_Previews: PreviewProvider {
//    static var previews: some View {
//        MedSelectView()
//    }
//}
