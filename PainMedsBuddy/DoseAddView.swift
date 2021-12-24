//
//  DoseAddView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct DoseAddView: View {
    let med: Med

    @EnvironmentObject var dataController: DataController

    var body: some View {
        DoseEditView(
            dataController: dataController,
            dose: dataController.createDose(selectedMed: med),
            add: true
        )
    }
}

struct DoseAddView_Previews: PreviewProvider {
    static var previews: some View {
        DoseAddView(med: Med())
    }
}
