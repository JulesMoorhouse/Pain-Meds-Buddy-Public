//
//  Med-CoreDataHelpers.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation

extension Med {
    var medDefaultTitle: String {
        defaultTitle ?? ""
    }

    var medDefaultAmount: Decimal {
        (defaultAmount ?? 0.0) as Decimal
    }

    var medDosage: Decimal {
        (dosage ?? 0.0) as Decimal
    }
    
    var medForm: String {
        form ?? ""
    }

    var medMeasure: String {
        measure ?? ""
    }
    
    var medNotes: String {
        notes ?? ""
    }
    
    var medCreationDate: Date {
        creationDate ?? Date()
    }
    
    static var example: Med {
        let controller =  DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let med = Med(context: viewContext)
        med.defaultTitle = "Example med"
        med.notes = "This is an exmaple med"
        med.defaultAmount = 1
        med.dosage = 300
        med.measure = "mg"
        med.form = "Pill"
        med.sequence = 3
        med.remaining = 99
        med.creationDate = Date()
        
        return med
    }
}
