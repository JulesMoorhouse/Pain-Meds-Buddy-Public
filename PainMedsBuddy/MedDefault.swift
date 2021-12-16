//
//  DoseMedDefault.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation
import SwiftUI

struct MedDefault {
    enum Sensible {
        static let title: String = NSLocalizedString("New Medication", comment: "")
        static let color: String = "Dark Blue"
        static let defaultAmount: NSDecimalNumber = 1.0
        static let lastTakeDate = Date()
        static let createdDate = Date()
        static let duration: Int16 = 60 * 4
        static let durationGap: Int16 = 0
        static let dosage: NSDecimalNumber = 100
        static let remaining: Int16 = 100
        static let sequence: Int16 = 0
        static let measure: String = NSLocalizedString("mg", comment: "")
        static let form: String = NSLocalizedString("Pill", comment: "")
        static let symbol: String = "pills"
        static let notes: String = ""
    }

    static let title: String = NSLocalizedString("New Medication", comment: "")
    static let color: String = "Dark Blue"
    static let defaultAmount: NSDecimalNumber = 0.0
    static let lastTakeDate = Date()
    static let createdDate = Date()
    static let duration: Int16 = 0
    static let durationGap: Int16 = 0
    static let dosage: NSDecimalNumber = 0
    static let remaining: Int16 = 0
    static let sequence: Int16 = 0
    static let measure: String = NSLocalizedString("mg", comment: "")
    static let form: String = ""
    static let symbol: String = "pills"
    static let notes: String = ""

    static func setDefaults(_ med: Med) {
        med.title = "\(MedDefault.title)"
        med.color = MedDefault.color
        med.defaultAmount = MedDefault.defaultAmount
        med.lastTakenDate = MedDefault.lastTakeDate
        med.creationDate = MedDefault.createdDate
        med.duration = MedDefault.duration
        med.durationGap = MedDefault.durationGap
        med.dosage = MedDefault.dosage
        med.remaining = MedDefault.remaining
        med.sequence = MedDefault.sequence
        med.measure = "\(MedDefault.measure)"
        med.form = MedDefault.form
        med.symbol = MedDefault.symbol
        med.notes = MedDefault.notes
    }

    static func setSensibleDefaults(_ med: Med) {
        med.title = "\(MedDefault.Sensible.title)"
        med.color = MedDefault.Sensible.color
        med.defaultAmount = MedDefault.Sensible.defaultAmount
        med.lastTakenDate = MedDefault.Sensible.lastTakeDate
        med.creationDate = MedDefault.Sensible.createdDate
        med.duration = MedDefault.Sensible.duration
        med.durationGap = MedDefault.Sensible.durationGap
        med.dosage = MedDefault.Sensible.dosage
        med.remaining = MedDefault.Sensible.remaining
        med.sequence = MedDefault.Sensible.sequence
        med.measure = "\(MedDefault.Sensible.measure)"
        med.form = MedDefault.Sensible.form
        med.symbol = MedDefault.Sensible.symbol
        med.notes = MedDefault.Sensible.notes
    }
}
