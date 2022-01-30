//
//  InterpolatedStrings.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation

struct InterpolatedStrings {
    static func doseProgressAccessibilityRemaining(dose: Dose, med: Med) -> String {
        String(.doseProgressAccessibilityRemaining,
               values: [
                   med.medTitle,
                   dose.doseDisplay,
                   dose.doseCountDownSeconds(nowDate: Date()),
               ])
    }

    static func doseProgressAccessibilityAvailable(dose: Dose, med: Med) -> String {
        String(.doseProgressAccessibilityAvailable,
               values: [
                   med.medTitle,
                   dose.doseDisplay,
                   dose.doseCountDownSeconds(nowDate: Date()),
               ])
    }

    static func doseProgressAccessibilityCloseButton(med: Med) -> String {
        String(.doseProgressAccessibilityCloseButton,
               values: [med.medTitle])
    }

    static func homeAccessibilityIconTaken(dose: Dose, med: Med) -> String {
        String(.homeAccessibilityIconTaken,
               values: [med.medColor,
                        med.medSymbolLabel,
                        med.medTitle,
                        dose.doseDisplay,
                        dose.doseFormattedTakenTimeShort])
    }

    static func homeAccessibilityIconTakeNow(med: Med) -> String {
        String(.homeAccessibilityIconTakeNow,
               values: [med.medColor,
                        med.medSymbolLabel,
                        med.medTitle,
                        med.medDisplay,
                        med.medFormattedLastTakenDate])
    }

    static func homeAccessibilityIconRemaining(med: Med) -> String {
        String(.homeAccessibilityIconRemaining,
               values: [med.medColor,
                        med.medSymbolLabel,
                        med.medTitle,
                        med.medRemaining,
                        med.medFormPlural])
    }

    static func medEditCopiedSuffix(title: String) -> String {
        String(.medEditCopiedSuffix, values: [title])
    }

    static func settingSupportMessage(values: [String]) -> String {
        if values.count != 8 {
            fatalError("ERROR: settingSupportMessage - wrong number of array items")
        }
        return String(.settingSupportMessage, values: values)
    }

    static func settingSupportSubject(version: String) -> String {
        String(.settingSupportSubject, values: [version])
    }
}
