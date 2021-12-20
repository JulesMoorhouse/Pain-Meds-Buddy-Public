//
//  Strings.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

enum Strings: LocalizedStringKey {
    case commonBasicSettings
    case commonDelete
    case commonDosage
    case commonEgString
    case commonEgNum
    case commonOK
    case commonSort
    case commonEmptyView
    case commonPleaseSelect
    case commonPleaseAdd
    
    case tabTitleHistory
    case tabTitleHome
    case tabTitleInProgress
    case tabTitleMedication
    case tabTitleSettings
    
    case homeCurrentMeds
    case homeMedsRunningOut
    case homeRecentlyTaken
    case homeTakeNext
    case homeTakeNow
    case homeAccessibilityIconRemaining
    case homeAccessibilityIconTaken
    case homeAccessibilityIconTakeNow
    case homeAccessibilityAvailable
    
    case doseProgressUnknownMedication
    case doseProgressAccessibilityAvailable
    case doseProgressAccessibilityRemaining
    
    case selectMedSelectMed
    
    case doseEditAddDose
    case doseEditAreYouSure
    case doseEditAmount
    case doseEditDateTime
    case doseEditDeleteDose
    case doseEditDeleteThisDose
    case doseEditEditDose
    
    case sortOptimized
    case sortCreatedDate
    case sortSortOrder
    case sortTitle
    
    case medsMedications
    case medsSorryUsed
    case medsPleaseSelect
    
    case medEditGapInfo
    case medEditAddMed
    case medEditAreYouSure
    case medEditColour
    case medEditDefaultAmount
    case medEditDefaultText
    case medEditDeleteMed
    case medEditDeleteThisMed
    case medEditDurationGap
    case medEditDuration
    case medEditEditMed
    case medEditExampleDosage
    case medEditForm
    case medEditImage
    case medEditInfo
    case medEditMeasure
    case medEditMg
    case medEditNewMedication
    case medEditNotes
    case medEditPill
    case medEditRemaining
    case medEditSequence
    case medEditSorry
    
    case settingsAcknowledgements
    case settingsAddExampleData
    case settingsDeleteAllData
}

extension Text {
    init(_ localizedString: Strings) {
        self.init(localizedString.rawValue)
    }
    
    init(_ localizedString: Strings, values: [String]) {
        
        let string: String = "\(localizedString.rawValue)"
        
        let output = String(format: NSLocalizedString(string, comment: ""), arguments: values)

        self.init(output)
    }
    
    init(_ localizedString: Strings, comment: StaticString) {
        self.init(localizedString.rawValue, tableName: nil, bundle: nil, comment: comment)
    }
}

extension String {
    init(_ localizedString: Strings, values: [String]) {
        let string: String = "\(localizedString.rawValue)"

        let output = NSLocalizedString(string, comment: "")
        
        self.init(format: output, arguments: values)
    }
}
