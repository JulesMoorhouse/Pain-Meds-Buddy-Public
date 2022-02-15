//
//  LocalisedStringTests.swift
//  PainMedsBuddyTests
//
//  Created by Jules Moorhouse.
//

// swiftlint:disable cyclomatic_complexity
// swiftlint:disable type_body_length
// swiftlint:disable function_body_length

@testable import PainMedsBuddy
import XCTest

class LocalisedStringTests: BaseTestCase {
    func testInterpolation() {
        // INFO: As a basic step this test ensure that all localised strings have the
        // correct number of interpolation parameters. Later this could included checks
        // on the actual parameters. Also adding new Strings enum items will cause an
        // error here, so highlighting that new tests should be considered
        let dose = Dose.example
        let med = Med.example
        dose.med = med

        var output = ""

        print("--------")
        for item in Strings.allCases {
            switch item {
            case .nothing:
                output = ""
            case .commonAppName:
                output = ""
            case .commonAppNameInitials:
                output = ""
            case .commonAdd:
                output = ""
            case .commonBasicSettings:
                output = ""
            case .commonCancel:
                output = ""
            case .commonClose:
                output = ""
            case .commonDelete:
                output = ""
            case .commonDosage:
                output = ""
            case .commonEgString:
                output = ""
            case .commonEmptyView:
                output = ""
            case .commonExampleDosage:
                output = ""
            case .commonErrorMessage:
                output = InterpolatedStrings
                    .commonErrorMessage(
                        error: "An example error")
            case .commonInfo:
                output = ""
            case .commonOK:
                output = ""
            case .commonMedications:
                output = ""
            case .commonNoDate:
                output = ""
            case .commonNotTakenYet:
                output = ""
            case .commonPleaseSelect:
                output = ""
            case .commonPleaseAdd:
                output = ""
            case .commonSave:
                output = ""
            case .commonSort:
                output = ""
            case .commonYes:
                output = ""
            // --------------------------
            case .validationTwoLetters:
                output = InterpolatedStrings
                    .validationTwoLetters(
                        field: String(.medEditTitle))

            case .validationOneOrAbove:
                output = InterpolatedStrings
                    .validationOneOrAbove(
                        field: String(.commonDosage))

            case .validationMustSpecify:
                output = InterpolatedStrings
                    .validationMustSpecify(
                        field: String(.medEditDuration))

            case .validationMustEmpty:
                output = InterpolatedStrings
                    .validationMustEmpty(
                        field: String(.medEditForm))

            case .validationZeroOrAbove:
                output = InterpolatedStrings
                    .validationZeroOrAbove(
                        field: String(.doseEditAmount))

            // --------------------------
            case .tabTitleHistory:
                output = ""
            case .tabTitleHome:
                output = ""
            case .tabTitleInProgress:
                output = ""
            case .tabTitleMedications:
                output = ""
            case .tabTitleSettings:
                output = ""
            // --------------------------
            case .homeCurrentMeds:
                output = ""
            case .homeEditDose:
                output = ""
            case .homeMedsRunningOut:
                output = ""
            case .homeRecentlyTaken:
                output = ""
            case .homeTakeNext:
                output = ""
            case .homeTakeNow:
                output = ""
            case .homeAccessibilityIconRemaining:
                output =
                    InterpolatedStrings
                        .homeAccessibilityIconRemaining(
                            med: med)

            case .homeAccessibilityIconRemainingEdit:
                output =
                    InterpolatedStrings.homeAccessibilityIconRemainingEdit(
                        med: med)

            case .homeAccessibilityIconTaken:
                output =
                    InterpolatedStrings
                        .homeAccessibilityIconTaken(
                            dose: dose, med: med)

            case .homeAccessibilityIconTakeNow:
                output =
                    InterpolatedStrings
                        .homeAccessibilityIconTakeNow(med: med)

            case .homeAccessibilityAvailable:
                output = "" // NOTE: No currently used
            // --------------------------
            case .doseProgressAvailable:
                output = ""
            case .doseProgressUnknownMedication:
                output = ""
            case .doseProgressAccessibilityAvailable:
                output =
                    InterpolatedStrings
                        .doseProgressAccessibilityAvailable(
                            dose: dose, med: med)

            case .doseProgressAccessibilityRemaining:
                output =
                    InterpolatedStrings
                        .doseProgressAccessibilityRemaining(
                            dose: dose, med: med)

            case .doseProgressAccessibilityCloseButton:
                output = InterpolatedStrings
                    .doseProgressAccessibilityCloseButton(
                        med: med)

            case .selectMedSelectMed:
                output = ""
            // --------------------------
            case .doseEditAccessibilityNoCurrentMeds:
                output = ""
            case .doseEditAddDose:
                output = ""
            case .doseEditAreYouSureDelete:
                output = ""
            case .doseEditAreYouSureElapse:
                output = ""
            case .doseEditAmount:
                output = ""
            case .doseElapsedLabel:
                output = ""
            case .doseElapsedReminder:
                output = ""
            case .doseElapsedReminderAlertTitle:
                output = ""
            case .doseElapsedReminderAlertMessage:
                output = ""
            case .doseElapsedReminderAlertButton:
                output = ""
            case .doseEditDateTime:
                output = ""
            case .doseEditDeleteDose:
                output = ""
            case .doseEditDeleteThisDose:
                output = ""
            case .doseEditDetails:
                output = ""
            case .doseEditDetailsPlaceholder:
                output = ""
            case .doseEditDosageElapsed:
                output = InterpolatedStrings
                    .doseEditDosageElapsed(
                        shortDateTime: Date().dateToShortDateTime)

            case .doseEditEditDose:
                output = ""
            case .doseEditElapseDose:
                output = ""
            case .doseEditMarkElapsed:
                output = ""
            case .doseEditMedication:
                output = ""
            case .doseEditInitialNotificationsError:
                output = ""
            // --------------------------
            case .sortOptimised:
                output = ""
            case .sortCreatedDate:
                output = ""
            case .sortSortOrder:
                output = ""
            case .sortTitle:
                output = ""
            // --------------------------
            case .medsMedications:
                output = ""
            case .medsSorryUsed:
                output = ""
            case .medsPleaseSelect:
                output = ""
            // --------------------------
            case .medEditAdvancedExpandedAID:
                output = ""
            case .medEditTitleLabelAID:
                output = ""
            case .medEditTitleText:
                output = ""
            case .medEditGapInfo:
                output = ""
            case .medEditAddMed:
                output = ""
            case .medEditDeleteAreYouSure:
                output = ""
            case .medEditDeleteHistoryAreYouSure:
                output = ""
            case .medEditColour:
                output = ""
            case .medEditCopyThisMed:
                output = ""
            case .medEditCopied:
                output = ""
            case .medEditCopiedSuffix:
                output =
                    InterpolatedStrings
                        .medEditCopiedSuffix(
                            title: "New Medication 1")

            case .medEditDefaultAmount:
                output = ""
            case .medEditDefaultText:
                output = ""
            case .medEditDeleteMed:
                output = ""
            case .medEditDeleteThisMed:
                output = ""
            case .medEditDeleteMedDoseHistory:
                output = ""
            case .medEditDurationGap:
                output = ""
            case .medEditDurationGapPickerHourAID:
                output = ""
            case .medEditDurationGapPickerMinuteAID:
                output = ""
            case .medEditDuration:
                output = ""
            case .medEditDurationPickerHourAID:
                output = ""
            case .medEditDurationPickerMinuteAID:
                output = ""
            case .medEditEditMed:
                output = ""
            case .medEditForm:
                output = ""
            case .medEditImage:
                output = ""
            case .medEditLockedField:
                output = ""
            case .medEditLowToast:
                output = InterpolatedStrings
                    .medEditLowToast(med: med)

            case .medEditMeasure:
                output = ""
            case .medEditMg:
                output = ""
            case .medEditNewMedication:
                output = ""
            case .medEditNotes:
                output = ""
            case .medEditNotesPlaceholder:
                output = ""
            case .medEditPill:
                output = ""
            case .medEditRemaining:
                output = ""
            case .medEditSorry:
                output = ""
            case .medEditSymbol:
                output = ""
            case .medEditTitle:
                output = ""
            case .medEditTypes:
                output = ""
            // --------------------------
            case .settingsAcknowledgements:
                output = ""
            case .settingsAdvanced:
                output = ""
            case .settingsAddExampleData:
                output = ""
            case .settingsAreYouSureDeleteAll:
                output = ""
            case .settingsAreYouSureDeleteAllHistory:
                output = ""
            case .settingsAreYouSureExampleData:
                output = ""
            case .settingsAreYouSureCrashTest:
                output = ""
            case .settingsBackup:
                output = ""
            case .settingsBackupFooter:
                output = ""
            case .settingsBackupAlertTitle:
                output = ""
            case .settingsBackupCompletedMessage:
                output = ""
            case .settingsCrashTestAlertTitle:
                output = ""
            case .settingsDeleteAllData:
                output = ""
            case .settingsDeleteAllAlertTitle:
                output = ""
            case .settingsDeleteAllDataCompleted:
                output = ""
            case .settingsDeleteAllHistoryData:
                output = ""
            case .settingsDeleteAllHistoryAlertTitle:
                output = ""
            case .settingsDeleteAllHistoryDataCompleted:
                output = ""
            case .settingsDefaultRemindMe:
                output = ""
            case .settingsDefaultRemindMeFooter:
                output = ""
            case .settingsDeveloper:
                output = ""
            case .settingsExampleDataAlertTitle:
                output = ""
            case .settingsGenerateTestCrash:
                output = ""
            case .settingsNoResponsibility:
                output = ""
            case .settingsRestore:
                output = ""
            case .settingsRestoreAlertTitle:
                output = ""
            case .settingsRestoreAreYouSure:
                output = ""
            case .settingsRestoreCompletedMessage:
                output = ""
            case .settingSupportButton:
                output = ""
            case .settingSupportCopied:
                output = ""
            case .settingSupportSubject:
                output = InterpolatedStrings
                    .settingSupportSubject(
                        appInitials: "PMB",
                        version: "1.2.3")
            case .settingSupportMessage:
                let code: String =
                    Locale.preferredLanguages[0]
                let language: String =
                    NSLocale.current.localizedString(forLanguageCode: code)!

                output = InterpolatedStrings
                    .settingSupportMessage(values: [
                        "PMB",
                        "iPhone Xr",
                        "14.5",
                        "\(language) (\(code))",
                        "\(10)",
                        "\(10)",
                        "27/01/2022",
                        "\(30)",
                        "\(Bundle.main.buildDate)",
                    ])
            // --------------------------
            case .notificationSubtitle:
                output = ""
            // --------------------------
            case .timePickerHours:
                output = InterpolatedStrings
                    .timePickerHours(number: "5")

            case .timePickerMins:
                output = InterpolatedStrings
                    .timePickerMins(number: "55")
            }

            if !output.isEmpty {
                print("LOCAL: \(item.rawValue.stringKey): \(output)")
                print(" ")
            }
        }
        print("--------")
    }
}
