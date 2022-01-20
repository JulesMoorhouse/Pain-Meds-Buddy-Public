//
//  Strings.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

enum Strings: LocalizedStringKey, CaseIterable {
    case commonBasicSettings
    case commonCancel
    case commonDelete
    case commonDosage
    case commonEgString
    case commonEmptyView
    case commonOK
    case commonMedications
    case commonNoDate
    case commonNotTakenYet
    case commonPleaseSelect
    case commonPleaseAdd
    case commonSave
    case commonSort
    // --------------------------
    case validationTwoLetters
    case validationOneOrAbove
    case validationMustSpecify
    case validationMustEmptySuffixS
    // --------------------------
    case titleHome
    case tabTitleHistory
    case tabTitleHome
    case tabTitleInProgress
    case tabTitleMedications
    case tabTitleSettings
    // --------------------------
    case homeCurrentMeds
    case homeMedsRunningOut
    case homeRecentlyTaken
    case homeTakeNext
    case homeTakeNow
    case homeAccessibilityIconRemaining
    case homeAccessibilityIconTaken
    case homeAccessibilityIconTakeNow
    case homeAccessibilityAvailable
    // --------------------------
    case doseProgressAvailable
    case doseProgressUnknownMedication
    case doseProgressAccessibilityAvailable
    case doseProgressAccessibilityRemaining
    // --------------------------
    case selectMedSelectMed
    // --------------------------
    case doseEditAddDose
    case doseEditAreYouSure
    case doseEditAmount
    case doseElapsedReminder
    case doseElapsedReminderAlertTitle
    case doseElapsedReminderAlertMessage
    case doseElapsedReminderAlertButton
    case doseEditDateTime
    case doseEditDeleteDose
    case doseEditDeleteThisDose
    case doseEditDetails
    case doseEditDetailsPlaceholder
    case doseEditEditDose
    case doseEditMedication
    // --------------------------
    case sortOptimised
    case sortCreatedDate
    case sortSortOrder
    case sortTitle
    // --------------------------
    case medsMedications
    case medsSorryUsed
    case medsPleaseSelect
    // --------------------------
    case medEditTitleLabelAID
    case medEditTitleText
    case medEditGapInfo
    case medEditAddMed
    case medEditAreYouSure
    case medEditColour
    case medEditCopyThisMed
    case medEditCopied
    case medEditCopiedSuffix
    case medEditDefaultAmount
    case medEditDefaultText
    case medEditDeleteMed
    case medEditDeleteThisMed
    case medEditDurationGap
    case medEditDuration
    case medEditEditMed
    case medEditExampleDosage
    case medEditHiddenTitle
    case medEditForm
    case medEditImage
    case medEditInfo
    case medEditLowToast
    case medEditMeasure
    case medEditMg
    case medEditNewMedication
    case medEditNotes
    case medEditNotesPlaceholder
    case medEditPill
    case medEditRemaining
    case medEditSorry
    case medEditSymbol
    case medEditTitle
    // --------------------------
    case settingsAcknowledgements
    case settingsAddExampleData
    case settingsDeleteAllData
    case settingsDefaultRemindMe
    case settingsGenerateTestCrash
    case settingsNoResponsibility
    // --------------------------
    case notificationSubtitle
    // --------------------------

    func automatedId() -> String {
        rawValue.stringKey
    }
}
