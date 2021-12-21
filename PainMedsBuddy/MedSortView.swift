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
        PopUpView(text: Strings.sortSortOrder.rawValue, content: {
            Button(action: {
                sortOrder = .optimzed
                showingSortOrder = false
            }) {
                ButtonBorderView(text: Strings.sortOptimized.rawValue)
            }
            .disabled(sortOrder == .optimzed)

            Button(action: {
                sortOrder = .creationDate
                showingSortOrder = false
            }) {
                ButtonBorderView(text: Strings.sortCreatedDate.rawValue)
            }
            .disabled(sortOrder == .creationDate)

            Button(action: {
                sortOrder = .title
                showingSortOrder = false
            }) {
                ButtonBorderView(text: Strings.sortTitle.rawValue)
            }
            .disabled(sortOrder == .title)
        }, close: {
            Button(action: {
                showingSortOrder = false
            }, label: {
                Image(systemName: "xmark")
                    .font(.headline)
            })
        })
    }
}

struct MedSortView_Previews: PreviewProvider {
    static var previews: some View {
        MedSortView(sortOrder: .constant(Med.SortOrder.optimzed), showingSortOrder: .constant(false))
    }
}
