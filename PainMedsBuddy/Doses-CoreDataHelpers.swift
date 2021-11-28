//
//  Doses-CoreDataHelpers.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation

extension Doses {
    var dosesTitle: String {
        title ?? ""
    }

    var dosesUnit: String {
        unit ?? ""
    }
    var dosesAmount: Decimal {
        (amount ?? 0.0) as Decimal
    }
    
    var dosesColor: String {
        color ?? "Light Blue"
    }
    
    var dosesGapPeriod: Decimal {
        (gapPeriod ?? 0.0) as Decimal
    }
    
    var dosesTakenDate: Date {
        takenDate ?? Date()
    }

    var dosesTaken: Bool {
        taken
    }
    
    static var example: Doses {
        let controller =  DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let doses = Doses(context: viewContext)
        doses.title = "Example dosage"
        doses.unit = "mg"
        doses.amount = 100
        doses.color = "Light Blue"
        doses.gapPeriod = 20.0
        doses.taken = true
        doses.takenDate = Date()
        
        return doses
    }
}


