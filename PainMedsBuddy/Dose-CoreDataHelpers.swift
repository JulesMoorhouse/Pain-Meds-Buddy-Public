//
//  Dose-CoreDataHelpers.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation

extension Dose {
    var doseTitle: String {
        title ?? ""
    }

    var doseAmount: Decimal {
        (amount ?? 0.0) as Decimal
    }
    
    var doseColor: String {
        color ?? "Light Blue"
    }
    
    var doseGapPeriod: Decimal {
        (gapPeriod ?? 0.0) as Decimal
    }
    
    var doseTakenDate: Date {
        takenDate ?? Date()
    }

    var doseTaken: Bool {
        taken
    }
    
    static var example: Dose {
        let controller =  DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let dose = Dose(context: viewContext)
        dose.title = "Paracetomol"
        dose.amount = 100
        dose.color = "Light Blue"
        dose.gapPeriod = 20.0
        dose.taken = true
        dose.takenDate = Date()
        
        return dose
    }
}


