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
        PopUpView(text: "Sort Order", content: {
            Button(action: {
                sortOrder = .optimzed
                showingSortOrder = false
            }) {
                ButtonBorderView(text: "Optimized")
            }
            .disabled(sortOrder == .optimzed)

            Button(action: {
                sortOrder = .creationDate
                showingSortOrder = false
            }) {
                ButtonBorderView(text: "Created Date")
            }
            .disabled(sortOrder == .creationDate)

            Button(action: {
                sortOrder = .title
                showingSortOrder = false
            }) {
                ButtonBorderView(text: "Title")
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
