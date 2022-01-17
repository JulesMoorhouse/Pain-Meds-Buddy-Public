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
        case optimised, title, creationDate, remaining, lastTaken
    }

    static let colours = [
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

    var medDurationSeconds: String {
        "\(String(describing: durationSeconds))"
    }

    var medDurationGapSeconds: String {
        "\(String(describing: durationGapSeconds))"
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

    var medTotalDosage: String {
        "\(medDefaultAmountDecimal * medDosageDecimal)"
    }

    var medDisplay: String {
        "\(medDefaultAmount) x \(medDosage)\(medMeasure) \(medForm) = \(medTotalDosage)\(medMeasure)"
    }

    var medDurationToTime: [Int] {
        let hours = Int(durationSeconds / 60) / 60
        let minutes = Int(durationSeconds / 60)
        return [hours, minutes]
    }

    var medDurationGapToTime: [Int] {
        let hours = Int(durationGapSeconds / 60) / 60
        let minutes = Int(durationGapSeconds / 60)
        return [hours, minutes]
    }

    var medTotalDurationToTime: [Int] {
        let hours = Int((durationSeconds + durationGapSeconds) / 60) / 60
        let minutes = Int((durationSeconds + durationGapSeconds) / 60)
        return [hours, minutes]
    }

    var medPredictedNextTimeCanTake: Date {
        // This will not cater for time asleep, will need those times in a setting in future
        if let date = lastTakenDate {
            return date.adding(seconds: medTotalDurationSeconds)
        }
        return Date()
    }

    /// Return the total time the medication is effective / duration plus any gap
    var medTotalDurationSeconds: Int {
        Int(durationSeconds) + Int(durationGapSeconds)
    }

    static var example: Med {
        let controller = DataController.preview
        let viewContext = controller.container.viewContext

        let med = Med(context: viewContext)
        med.title = "Example med"
        med.notes = "This is an example med"
        med.defaultAmount = 1
        med.color = Med.colours.randomElement()
        med.dosage = 300
        med.durationSeconds = (60 * 4) * 60
        med.durationGapSeconds = 0
        med.measure = "mg"
        med.form = "Pill"
        med.remaining = 99
        med.symbol = Symbol.allSymbols.randomElement()?.id
        med.creationDate = Date()
        med.lastTakenDate = Date()
        med.hidden = false

        return med
    }
}
