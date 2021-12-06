//
//  Meds-ArrayHelpers.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation

extension Array where Element: Med {
    var allMeds: [Med] {
        self
    }
    
    var allMedsDefaultSorted: [Med] {
        allMeds.sorted { (first: Med, second: Med) in
            if first.remaining > second.remaining {
                return true
            } else if first.remaining < second.remaining {
                return false
            }

            if first.medDefaultTitle > second.medDefaultTitle {
                return true
            } else if first.medDefaultTitle < second.medDefaultTitle {
                return false
            }

            if first.sequence > second.sequence {
                return true
            } else if first.sequence < second.sequence {
                return false
            }

            return first.medCreationDate < second.medCreationDate
        }
    }
}
