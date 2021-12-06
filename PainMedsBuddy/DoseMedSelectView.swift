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

    var body: some View {
        Form {
            ForEach(0 ..< meds.count) { index in
                HStack {
                    Text(self.meds[index].medDefaultTitle)
                        .foregroundColor(Color(self.meds[index].color ?? "Black"))
                    Spacer()
                    Text("\(self.meds[index].remaining) \(self.meds[index].medForm)")

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

//struct DoseMedSelectView_Previews: PreviewProvider {
//    static var previews: some View {
//        DoseMedSelectView()
//    }
//}
