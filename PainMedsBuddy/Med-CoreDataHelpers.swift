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
    
    var medDefaultUnit: String {
        defaultUnit ?? ""
    }

    var medDefaultAmount: Decimal {
        (defaultAmount ?? 0.0) as Decimal
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
        med.defaultUnit = "mg"
        med.defaultAmount = 100
        med.sequence = 3
        med.remaining = 99
        med.creationDate = Date()
        
        return med
    }
}
