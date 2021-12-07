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
        med.creationDate = Date()
        dataController.save()
        
        return MedEditView(med: med, add: true)
    }
}

struct MedAddView_Previews: PreviewProvider {
    static var previews: some View {
        MedAddView()
    }
}
