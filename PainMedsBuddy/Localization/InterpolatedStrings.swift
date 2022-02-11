//
//  InterpolatedStrings.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation

struct InterpolatedStrings {
    static func doseElapsedLabel(dose: Dose) -> String {
        String(.doseElapsedLabel, values: [dose.doseElapsedDateString])
    }

    static func doseProgressAccessibilityRemaining(dose: Dose, med: Med) -> String {
        String(.doseProgressAccessibilityRemaining,
               values: [
                   med.medColor,
                   med.medSymbolLabel,
                   med.medTitle,
                   dose.doseDisplay,
                   dose.doseCountDownSeconds(nowDate: Date()),
               ])
    }

    static func doseProgressAccessibilityAvailable(dose: Dose, med: Med) -> String {
        String(.doseProgressAccessibilityAvailable,
               values: [
                   med.medColor,
                   med.medSymbolLabel,
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

    static func homeAccessibilityIconRemainingEdit(med: Med) -> String {
        String(.homeAccessibilityIconRemainingEdit,
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
        if values.count != 9 {
            fatalError("ERROR: settingSupportMessage - wrong number of array items")
        }
        return String(.settingSupportMessage, values: values)
    }

    static func settingSupportSubject(
        appInitials: String,
        version: String) -> String
    {
        String(.settingSupportSubject, values: [appInitials, version])
    }

    static func validationTwoLetters(field: String) -> String {
        String(.validationTwoLetters, values: [field])
    }

    static func validationOneOrAbove(field: String) -> String {
        String(.validationOneOrAbove, values: [field])
    }

    static func validationMustSpecify(field: String) -> String {
        String(.validationMustSpecify, values: [field])
    }

    static func validationMustEmpty(field: String) -> String {
        String(.validationMustEmpty, values: [field])
    }

    static func validationZeroOrAbove(field: String) -> String {
        String(.validationZeroOrAbove, values: [field])
    }

    // NOTE: Not current used
//    static func homeAccessibilityAvailable() -> String {
//        String(.homeAccessibilityAvailable, values: [""])
//    }

    static func doseEditDosageElapsed(shortDateTime: String) -> String {
        String(.doseEditDosageElapsed, values: [shortDateTime])
    }

    static func medEditLowToast(med: Med) -> String {
        String(.medEditLowToast, values: [med.medTitle])
    }

    static func commonErrorMessage(error: String) -> String {
        String(.commonErrorMessage, values: [error])
    }

    static func timePickerHours(number: String) -> String {
        String(.timePickerHours, values: [number])
    }

    static func timePickerMins(number: String) -> String {
        String(.timePickerMins, values: [number])
    }
}
