//
//  Strings.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

enum Strings: LocalizedStringKey, CaseIterable {
    case nothing
    // --------------------------
    case commonAdd
    case commonAppName
    case commonAppNameInitials
    case commonBasicSettings
    case commonCancel
    case commonDelete
    case commonDosage
    case commonEgString
    case commonEmptyView
    case commonExampleDosage
    case commonErrorMessage
    case commonInfo
    case commonOK
    case commonMedications
    case commonNoDate
    case commonNotTakenYet
    case commonPleaseSelect
    case commonPleaseAdd
    case commonSave
    case commonSort
    case commonYes
    // --------------------------
    case validationTwoLetters
    case validationOneOrAbove
    case validationMustSpecify
    case validationMustEmpty
    case validationZeroOrAbove
    // --------------------------
    case tabTitleHistory
    case tabTitleHome
    case tabTitleInProgress
    case tabTitleMedications
    case tabTitleSettings
    // --------------------------
    case homeCurrentMeds
    case homeEditDose
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
    case doseProgressAccessibilityCloseButton
    // --------------------------
    case selectMedSelectMed
    // --------------------------
    case doseEditAddDose
    case doseEditAreYouSureDelete
    case doseEditAreYouSureElapse
    case doseEditAmount
    case doseElapsedLabel
    case doseElapsedReminder
    case doseElapsedReminderAlertTitle
    case doseElapsedReminderAlertMessage
    case doseElapsedReminderAlertButton
    case doseEditDateTime
    case doseEditDeleteDose
    case doseEditDeleteThisDose
    case doseEditDetails
    case doseEditDetailsPlaceholder
    case doseEditDosageElapsed
    case doseEditEditDose
    case doseEditElapseDose
    case doseEditMarkElapsed
    case doseEditMedication
    case doseEditInitialNotificationsError
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
    case medEditDurationGapPickerHourAID
    case medEditDurationGapPickerMinuteAID
    case medEditDuration
    case medEditDurationPickerHourAID
    case medEditDurationPickerMinuteAID
    case medEditEditMed
    case medEditForm
    case medEditImage
    case medEditLockedField
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
    case medEditTypes
    // --------------------------
    case settingsAcknowledgements
    case settingsAdvanced
    case settingsAddExampleData
    case settingsAreYouSureDeleteAll
    case settingsAreYouSureExampleData
    case settingsAreYouSureCrashTest
    case settingsBackup
    case settingsBackupFooter
    case settingsBackupAlertTitle
    case settingsBackupCompletedMessage
    case settingsCrashTestAlertTitle
    case settingsDeleteAllData
    case settingsDeleteAllAlertTitle
    case settingsDefaultRemindMe
    case settingsDefaultRemindMeFooter
    case settingsDeveloper
    case settingsExampleDataAlertTitle
    case settingsGenerateTestCrash
    case settingsNoResponsibility
    case settingsRestore
    case settingsRestoreAlertTitle
    case settingsRestoreAreYouSure
    case settingsRestoreCompletedMessage
    case settingSupportButton
    case settingSupportCopied
    case settingSupportSubject
    case settingSupportMessage
    // --------------------------
    case notificationSubtitle
    // --------------------------
    case timePickerHours
    case timePickerMins
    // --------------------------

    func automatedId() -> String {
        rawValue.stringKey
    }
}
