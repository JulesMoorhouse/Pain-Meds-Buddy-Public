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

    var doseAmount: String {
        "\(String(describing: amount ?? 0.0))"
    }
    
    var doseGapPeriod: String {
        "\(String(describing: gapPeriod ?? 0.0))"
    }
    
    var doseTakenDate: Date {
        takenDate ?? Date()
    }

    var doseTaken: Bool {
        taken
    }
    
    var doseFormattedTakenDate: String {
        if let date = takenDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter.string(from: date)
        } else {
            return "No date"
        }
    }

    var doseFormattedMYTakenDate: String {
        if let date = takenDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter.string(from: date)
        } else {
            return "No date"
        }
    }
    
    var doseTotalDosage: String {
        let temp = ((amount ?? 0.0) as Decimal) * ((self.med?.dosage ?? 0) as Decimal)
        return "\(temp)"
    }
    
    var doseDisplayFull: String {
        "\(doseAmount) x \(self.med?.medDosage ?? "0")\(self.med?.measure ?? "") \(self.med?.form ?? "") = \(doseTotalDosage)\(self.med?.measure ?? "")"
    }

    var doseDisplay: String {
        "\(doseAmount) x \(self.med?.medDosage ?? "0")\(self.med?.measure ?? "") \(self.med?.form ?? "")"
    }
    
    static var example: Dose {
        let controller =  DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let dose = Dose(context: viewContext)
        dose.title = "Paracetomol"
        dose.amount = 1
        dose.gapPeriod = 20.0
        dose.taken = true
        dose.takenDate = Date()
        
        return dose
    }
}


