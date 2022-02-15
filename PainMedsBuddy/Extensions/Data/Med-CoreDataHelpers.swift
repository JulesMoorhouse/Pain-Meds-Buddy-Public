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
        let item = SymbolModel.allSymbols.first(where: { $0.id == medSymbol })
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

    var medFormPlural: String {
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
            return date.dateToShortDateTime
        } else {
            return String(.commonNotTakenYet)
        }
    }

    var medCreationDate: Date {
        creationDate ?? MedDefault.createdDate
    }

    var medRemaining: String {
        "\(remaining ?? MedDefault.remaining)"
    }

    var medTotalDosage: String {
        "\(medDefaultAmountDecimal * medDosageDecimal)"
    }

    var medIsRunningLow: Bool {
        // NOTE: look at remaining amount e.g. 100 pills
        // look at default amount e.g. 2 pills
        // divide remain amount by default amount
        // this will give you number of remaining doses
        // if this is 5 or below then it's running low
        let tempRemaining =
            Double(truncating: remaining
                ?? MedDefault.remaining)

        let tempDefaultAmount =
            Double(truncating: defaultAmount
                ?? MedDefault.defaultAmount)

        let dosesLeft = tempRemaining / tempDefaultAmount

        let isRunningLow = dosesLeft <= 5

        return isRunningLow
    }

    var medDisplay: String {
        let tempForm
            = Med.formWord(
                num: Int(medDefaultAmount) ?? 0,
                word: form ?? MedDefault.form
            )

        return "\(medDefaultAmount) x \(medDosage)\(medMeasure) \(tempForm) = \(medTotalDosage)\(medMeasure)"
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
        // NOTE: This will not cater for time asleep, will need those times in a setting in future
        if let date = lastTakenDate {
            return date.adding(seconds: medTotalDurationSeconds)
        }
        return Date()
    }

    /// Return the total time the medication is effective / duration plus any gap
    var medTotalDurationSeconds: Int {
        Int(durationSeconds) + Int(durationGapSeconds)
    }

    static func formWord(num: Int, word: String) -> String {
        if num == 0 || word.isEmpty {
            return word
        } else if num == 1 {
            let lastChar = String(word.last!)
            if lastChar == "s" {
                return String(word.dropLast())
            }
        }
        return word
    }

    func setDefaults() {
        title = "\(MedDefault.title)"
        color = MedDefault.color
        defaultAmount = MedDefault.defaultAmount
        lastTakenDate = MedDefault.lastTakeDate
        creationDate = MedDefault.createdDate
        durationSeconds = MedDefault.duration
        durationGapSeconds = MedDefault.durationGap
        dosage = MedDefault.dosage
        remaining = MedDefault.remaining
        measure = "\(MedDefault.measure)"
        form = MedDefault.form
        symbol = MedDefault.symbol
        notes = MedDefault.notes
        if hidden {
            // Note: Should be necessary but if set to
            // false causes a refresh
            hidden = false
        }
    }

    func setSensible() {
        title = "\(MedDefault.Sensible.title)"
        color = MedDefault.Sensible.color
        defaultAmount = MedDefault.Sensible.defaultAmount
        lastTakenDate = MedDefault.Sensible.lastTakeDate
        creationDate = MedDefault.Sensible.createdDate
        durationSeconds = MedDefault.Sensible.duration
        durationGapSeconds = MedDefault.Sensible.durationGap
        dosage = MedDefault.Sensible.dosage
        remaining = NSDecimalNumber(value: MedDefault.Sensible.remaining)
        measure = "\(MedDefault.Sensible.measure)"
        form = MedDefault.Sensible.form
        symbol = MedDefault.Sensible.symbol
        notes = MedDefault.Sensible.notes
        if hidden {
            // Note: Should be necessary but if set to
            // false causes a refresh
            hidden = false
        }
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
        med.symbol = SymbolModel.allSymbols.randomElement()?.id
        med.creationDate = Date()
        med.lastTakenDate = Date()
        med.hidden = false

        return med
    }
}
