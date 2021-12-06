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
            Button(action: {
                sortOrder = .creationDate
                showingSortOrder = false
            }) {
                PopUpButtonView(text: "Created Date")
            }
            Button(action: {
                sortOrder = .title
                showingSortOrder = false
            }) {
                PopUpButtonView(text: "Title")
            }
        }    }
}

struct MedSortView_Previews: PreviewProvider {
    static var previews: some View {
        MedSortView(sortOrder: .constant(Med.SortOrder.optimzed), showingSortOrder: .constant(false))
    }
}
