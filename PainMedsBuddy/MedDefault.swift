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
        static let title = String(.medEditNewMedication)
        static let color: String = "Dark Blue"
        static let defaultAmount: NSDecimalNumber = 1.0
        static let lastTakeDate = Date()
        static let createdDate = Date()
        static let duration: Int16 = 60 * 4
        static let durationGap: Int16 = 0
        static let dosage: NSDecimalNumber = 100
        static let remaining: Int16 = 100
        static let sequence: Int16 = 0
        static let measure = String(.medEditMg)
        static let form = String(.medEditPill)
        static let symbol: String = "pills"
        static let notes: String = ""

        static func medDefaultAmount() -> String {
            "\(String(describing: MedDefault.Sensible.dosage))"
        }

        static func medDuration() -> String {
            "\(String(describing: MedDefault.Sensible.duration))"
        }

        static func medDurationGap() -> String {
            "\(String(describing: MedDefault.Sensible.durationGap))"
        }

        static func medDosage() -> String {
            "\(String(describing: MedDefault.Sensible.defaultAmount))"
        }

        static func medRemaining() -> String {
            "\(String(describing: MedDefault.Sensible.remaining))"
        }

        static func medSequence() -> String {
            "\(String(describing: MedDefault.Sensible.sequence))"
        }
    }

    static let title = String(.medEditNewMedication)
    static let color: String = "Dark Blue"
    static let defaultAmount: NSDecimalNumber = 0.0
    static let lastTakeDate = Date()
    static let createdDate = Date()
    static let duration: Int16 = 0
    static let durationGap: Int16 = 0
    static let dosage: NSDecimalNumber = 0
    static let remaining: Int16 = 0
    static let sequence: Int16 = 0
    static let measure = String(.medEditMg)
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
