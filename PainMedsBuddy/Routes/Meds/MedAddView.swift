//
//  MedAddView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct MedAddView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
        let med = Med(context: managedObjectContext)
        MedDefault.setSensibleDefaults(med)
        // med.creationDate = Date()
        // dataController.save()

        return MedEditView(
            dataController: dataController,
            med: med,
            add: true,
            hasRelationship: dataController.hasRelationship(for: med))
    }
}

struct MedAddView_Previews: PreviewProvider {
    static var previews: some View {
        MedAddView()
    }
}
