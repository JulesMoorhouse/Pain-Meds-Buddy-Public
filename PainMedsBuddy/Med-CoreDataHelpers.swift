//
//  Med-CoreDataHelpers.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation
import SwiftUI

extension Med: MedProtocol {
    public enum SortOrder {
        case optimzed, title, creationDate, remaining, lastTaken
    }

    static let colors = [
        "Pink",
        "Purple",
        "Red",
        "Orange",
        "Gold",
        "Green",
        "Teal",
        "Light Blue",
        "Dark Blue",
        "Midnight",
        "Dark Gray",
        "Gray",
    ]

    var medTitle: String {
        title ?? MedDefault.title
    }

    var medDefaultAmount: String {
        "\(medDefaultAmountDecimal)"
    }

    var medDefaultAmountDecimal: Decimal {
        if let amount = defaultAmount {
            if !Double(truncating: amount).isNaN {
                return amount as Decimal
            }
        }
        return MedDefault.defaultAmount as Decimal
    }

    var medColor: String {
        color ?? MedDefault.color
    }

    var medSymbol: String {
        symbol ?? MedDefault.symbol
    }

    var medSymbolLabel: String {
        let item = Symbol.allSymbols.first(where: { $0.id == medSymbol })
        if let item = item {
            return item.label
        }
        return ""
    }

    var medDosage: String {
        "\(medDosageDecimal)"
    }

    var medDosageDecimal: Decimal {
        if let dosage = dosage {
            if !Double(truncating: dosage).isNaN {
                return dosage as Decimal
            }
        }
        return MedDefault.dosage as Decimal
    }

    var medDuration: String {
        "\(String(describing: duration))"
    }

    var medDurationGap: String {
        "\(String(describing: durationGap))"
    }

    var medForm: String {
        form ?? MedDefault.form
    }

    var medMeasure: String {
        measure ?? MedDefault.measure
    }

    var medNotes: String {
        notes ?? MedDefault.notes
    }

    var medLastTakenDate: Date {
        lastTakenDate ?? MedDefault.lastTakeDate
    }

    var medFormattedLastTakenDate: String {
        if let date = lastTakenDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter.string(from: date)
        } else {
            return String(.commonNotTakenYet)
        }
    }

    var medCreationDate: Date {
        creationDate ?? MedDefault.createdDate
    }

    var medRemaining: String {
        "\(String(describing: remaining))"
    }

    var medSequence: String {
        "\(String(describing: sequence))"
    }

    var medTotalDosage: String {
        "\(medDefaultAmountDecimal * medDosageDecimal)"
    }

    var medDisplay: String {
        "\(medDefaultAmount) x \(medDosage)\(medMeasure) \(medForm) = \(medTotalDosage)\(medMeasure)"
    }

    var medDurationToTime: [Int] {
        let hours = Int(duration / 60)
        let minutes = Int(duration % 60)
        return [hours, minutes]
    }

    var medDurationGapToTime: [Int] {
        let hours = Int(durationGap / 60)
        let minutes = Int(durationGap % 60)
        return [hours, minutes]
    }

    var medTotalDurationToTime: [Int] {
        let hours = Int((duration + durationGap) / 60)
        let minutes = Int((duration + durationGap) % 60)
        return [hours, minutes]
    }

    var medTotalDuration: Int {
        Int(duration) + Int(durationGap)
    }

    static var example: Med {
        let controller = DataController(inMemory: true)
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
        med.lastTakenDate = Date()

        return med
    }
}
