//
//  Med-CoreDataHelpers.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation

extension Med {
    public enum SortOrder {
        case optimzed, title, creationDate
    }
    
    static let colors = ["Pink", "Purple", "Red", "Orange", "Gold", "Green", "Teal", "Light Blue", "Dark Blue", "Midnight", "Dark Gray", "Gray"]
    
    static let defaultColor = "Dark Blue"
    
    var medTitle: String {
        title ?? ""
    }

    var medDefaultAmount: String {
        "\(String(describing: defaultAmount ?? 0.0))"
    }

    var medColor: String {
        color ?? "Light Blue"
    }

    var medSymbol: String {
        symbol ?? "pills"
    }
    
    var medDosage: String {
        "\(String(describing: dosage ?? 0.0))"
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
    
    var medRemaining: String {
        "\(String(describing: remaining))"
    }
    
    var medSequence: String {
        "\(String(describing: sequence))"
    }
    
    var medTotalDosage: String {
        let temp = ((defaultAmount ?? 0.0) as Decimal) * ((dosage ?? 0) as Decimal)
        return "\(temp)"
    }
    
    var medDisplay: String {
        "\(medDefaultAmount) x \(medDosage)\(measure ?? "") \(form ?? "") = \(medTotalDosage)\(measure ?? "")"
    }
    
    var medDurationToTime: [Int] {
        let hours = Int(duration / 60);
        let minutes = Int(duration % 60);
        return [hours, minutes];
    }

    var medDurationGapToTime: [Int] {
        let hours = Int(durationGap / 60);
        let minutes = Int(durationGap % 60);
        return [hours, minutes];
    }
    
    static var example: Med {
        let controller =  DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let med = Med(context: viewContext)
        med.title = "Example med"
        med.notes = "This is an exmaple med"
        med.defaultAmount = 1
        med.color = Med.colors.randomElement()
        med.dosage = 300
        med.duration = 240
        med.durationGap = 0
        med.measure = "mg"
        med.form = "Pill"
        med.sequence = 3
        med.remaining = 99
        med.symbol = Symbol.allSymbols.randomElement()?.id
        med.creationDate = Date()
        
        return med
    }
}
