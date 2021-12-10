//
//  DoseAddView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct DoseAddView: View {
    let meds: [Med]
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
        let dose = Dose(context: managedObjectContext)
        dose.elapsed = false
        dose.takenDate = Date()
        dataController.save()
        
        return DoseEditView(dataController: dataController, meds: meds, dose: dose, add: true)
    }
}

struct DoseAddView_Previews: PreviewProvider {
    static var previews: some View {
        DoseAddView(meds: [Med()])
    }
}
