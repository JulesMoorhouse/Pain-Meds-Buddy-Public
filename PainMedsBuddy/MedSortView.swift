//
//  MedSortView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct MedSortView: View {
    @Binding var sortOrder: Med.SortOrder
    @Binding var showingSortOrder: Bool

    var body: some View {
        PopUpView(text: "Sort Order") {
            Button(action: {
                sortOrder = .optimzed
                showingSortOrder = false
            }) {
                PopUpButtonView(text: "Optimized")
            }
            .disabled(sortOrder == .optimzed)

            Button(action: {
                sortOrder = .creationDate
                showingSortOrder = false
            }) {
                PopUpButtonView(text: "Created Date")
            }
            .disabled(sortOrder == .creationDate)

            Button(action: {
                sortOrder = .title
                showingSortOrder = false
            }) {
                PopUpButtonView(text: "Title")
            }
            .disabled(sortOrder == .title)
        }
    }
}

struct MedSortView_Previews: PreviewProvider {
    static var previews: some View {
        MedSortView(sortOrder: .constant(Med.SortOrder.optimzed), showingSortOrder: .constant(false))
    }
}
