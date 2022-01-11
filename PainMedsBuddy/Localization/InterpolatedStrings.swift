//
//  InterpolatedStrings.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation

struct InterpolatedStrings {
    
    static func doseProgressAccessibilityRemaining(dose: Dose, med: Med) -> String {
        return String(.doseProgressAccessibilityRemaining, values: [med.medTitle, dose.doseDisplay, dose.doseCountDownSeconds])
    }
    
    static func doseProgressAccessibilityAvailable(dose: Dose, med: Med) -> String {
        return String(.doseProgressAccessibilityAvailable, values: [med.medTitle, dose.doseDisplay, dose.doseCountDownSeconds])
    }
    
    static func homeAccessibilityIconTaken(dose: Dose, med: Med) -> String {
        return String(.homeAccessibilityIconTaken,
                      values: [med.medColor,
                               med.medSymbolLabel,
                               med.medTitle,
                               dose.doseDisplay,
                               dose.doseFormattedTakenDate])
    }
    
    static func homeAccessibilityIconTakeNow(med: Med) -> String {
        return String(.homeAccessibilityIconTakeNow,
                      values: [med.medColor,
                               med.medSymbolLabel,
                               med.medTitle,
                               med.medDisplay,
                               med.medFormattedLastTakenDate])
    }
    
    static func homeAccessibilityIconRemaining(med: Med) -> String {
        return String(.homeAccessibilityIconRemaining,
                      values: [med.medColor,
                               med.medSymbolLabel,
                               med.medTitle,
                               med.medRemaining,
                               med.medForm])
    }
    
    static func medEditCopiedSuffix(title: String) -> String {
        return String(.medEditCopiedSuffix, values: [title])
    }
}
