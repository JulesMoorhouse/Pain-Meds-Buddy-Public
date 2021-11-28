//
//  Medication-CoreDataHelpers.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation

extension Medication {
    var medicationTitle: String {
        title ?? ""
    }
    
    var medicationDetail: String {
        detail ?? ""
    }
    
    var medicationCreationDate: Date {
        creationDate ?? Date()
    }
    
    static var example: Medication {
        let controller =  DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let medication = Medication(context: viewContext)
        medication.title = "Example med"
        medication.detail = "This is an exmaple med"
        medication.sequence = 3
        medication.creationDate = Date()
        
        return medication
    }
}
