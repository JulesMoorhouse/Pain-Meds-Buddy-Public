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
            if first.sequence > second.sequence {
                return true
            } else if first.sequence < second.sequence {
                return false
            }
            
            if first.remaining > second.remaining {
                return true
            } else if first.remaining < second.remaining {
                return false
            }

            if first.medTitle > second.medTitle {
                return true
            } else if first.medTitle < second.medTitle {
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
        default:
            return allMeds.allMedsDefaultSorted
        }
    }
}
