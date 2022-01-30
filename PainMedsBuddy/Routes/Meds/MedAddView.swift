//
//  MedAddView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct MedAddView: View {
    @EnvironmentObject var dataController: DataController

    var body: some View {
        MedEditView(
            dataController: dataController,
            med: nil,
            add: true,
            hasRelationship: false
        )
    }
}

struct MedAddView_Previews: PreviewProvider {
    static var previews: some View {
        MedAddView()
    }
}
