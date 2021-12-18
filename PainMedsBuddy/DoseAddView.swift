//
//  DoseAddView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct DoseAddView: View {
    let med: Med?

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    var firstMed: Med? {
        dataController.getFirstMed()
    }
    
    var body: some View {
        let dose = Dose(context: managedObjectContext)
        DoseDefault.setSensibleDefaults(dose)

        if let med = med {
            if dose.med != med {
                dose.med = med
            }
        } else {
            if let first = firstMed {
                if dose.med != first {
                    dose.med = first
                }
            }
        }
        // dataController.save()

        return DoseEditView(dataController: dataController, dose: dose, add: true)
    }
}

struct DoseAddView_Previews: PreviewProvider {
    static var previews: some View {
        DoseAddView(med: nil)
    }
}
