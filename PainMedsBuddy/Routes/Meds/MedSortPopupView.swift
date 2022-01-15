//
//  MedSortView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct MedSortPopupView: View {
    @Binding var sortOrder: Med.SortOrder
    @Binding var showingSortOrder: Bool

    var body: some View {
        PopUpView(text: Strings.sortSortOrder.rawValue, content: {
            Button(action: {
                sortOrder = .optimised
                showingSortOrder = false
            }, label: {
                ButtonBorderView(text: Strings.sortOptimised.rawValue)
            })
                .disabled(sortOrder == .optimised)
                .padding(.bottom, 5)

            Button(action: {
                sortOrder = .creationDate
                showingSortOrder = false
            }, label: {
                ButtonBorderView(text: Strings.sortCreatedDate.rawValue)
            })
                .disabled(sortOrder == .creationDate)
                .padding(.bottom, 5)

            Button(action: {
                sortOrder = .title
                showingSortOrder = false
            }, label: {
                ButtonBorderView(text: Strings.sortTitle.rawValue)
            })
                .disabled(sortOrder == .title)
        },
        leftButton: {},
        rightButton: {
            Button(action: {
                showingSortOrder = false
            }, label: {
                Image(systemName: SFSymbol.xMark.systemName)
                    .font(.headline)
            })
        },
        bottomButton: {})
    }
}

struct MedSortPopupView_Previews: PreviewProvider {
    static var previews: some View {
        MedSortPopupView(sortOrder: .constant(Med.SortOrder.optimised), showingSortOrder: .constant(false))
    }
}
