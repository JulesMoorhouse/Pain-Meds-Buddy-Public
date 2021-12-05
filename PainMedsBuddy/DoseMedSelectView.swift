//
//  DoseMedSelectView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct DoseMedSelectView: View {
    @Environment(\.presentationMode) var presentationMode

    var meds: FetchedResults<Med>
    @Binding var selectedMedIndex: Int

    var body: some View {
        Form {
            ForEach(0 ..< meds.count) { index in
                HStack {
                    Text(self.meds[index].medDefaultTitle)
                        .foregroundColor(Color(self.meds[index].color ?? "Black"))
                    Spacer()
                    Text("\(self.meds[index].remaining) \(self.meds[index].medForm)")

                    if self.selectedMedIndex == index {
                        Image(systemName: "checkmark")
                            .foregroundColor(Color.blue)
                    }
                }
                .contentShape(Rectangle())
                .foregroundColor(.primary)
                .onTapGesture {
                    self.selectedMedIndex = index
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
