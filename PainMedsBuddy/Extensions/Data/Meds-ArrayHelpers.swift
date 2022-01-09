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
            if first.medLastTakenDate > second.medLastTakenDate {
                return true
            } else if first.medLastTakenDate < second.medLastTakenDate {
                return false
            }
            return first.medCreationDate < second.medCreationDate
        }
    }

    public func sortedItems(using sortOrder: Med.SortOrder) -> [Med] {
        switch sortOrder {
        case .title:
            return allMeds.sorted(by: \Med.medTitle)
        case .creationDate:
            return allMeds.sorted(by: \Med.medCreationDate)
        case .remaining:
            return allMeds.sorted(by: \Med.remaining)
        case .lastTaken:
            return allMeds.sorted(by: \Med.medLastTakenDate)
        default:
            return allMeds.allMedsDefaultSorted
        }
    }
}
