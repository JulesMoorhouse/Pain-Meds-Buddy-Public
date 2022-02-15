//
//  DoseDefault.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation

struct DoseDefault {
    struct Sensible {
        static let amount: NSDecimalNumber = 1
        static let elapsed: Bool = false
        static let takenDate = Date()
        static let details: String = ""
        static let remindMe: Bool = true

        static func doseAmount() -> String {
            "\(String(describing: DoseDefault.Sensible.amount))"
        }
    }

    static let amount: NSDecimalNumber = 0
    static let elapsed: Bool = false
    static let takenDate = Date()
    static let details: String = ""
    static let remindMe: Bool = true
}
