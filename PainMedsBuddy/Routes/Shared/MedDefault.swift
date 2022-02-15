//
//  DoseMedDefault.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation
import SwiftUI

struct MedDefault {
    struct Sensible {
        static let title = String(.medEditNewMedication)
        static let color: String = "Dark Blue"
        static let defaultAmount: NSDecimalNumber = 1.0
        static let lastTakeDate = Date()
        static let createdDate = Date()
        static let duration: Int16 = 60 * 4
        static let durationGap: Int16 = 0
        static let dosage: NSDecimalNumber = 100
        static let remaining: Int16 = 100
        static let measure = String(.medEditMg)
        static let form = String(.medEditPill)
        static let symbol: String = "pills"
        static let notes: String = ""

        static func medDefaultAmount() -> String {
            "\(String(describing: MedDefault.Sensible.defaultAmount))"
        }

        static func medDuration() -> String {
            "\(String(describing: MedDefault.Sensible.duration))"
        }

        static func medDurationGap() -> String {
            "\(String(describing: MedDefault.Sensible.durationGap))"
        }

        static func medDosage() -> String {
            "\(String(describing: MedDefault.Sensible.dosage))"
        }

        static func medRemaining() -> String {
            "\(String(describing: MedDefault.Sensible.remaining))"
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
    static let remaining: NSDecimalNumber = 0
    static let measure = String(.medEditMg)
    static let form: String = ""
    static let symbol: String = "pills"
    static let notes: String = ""
}
