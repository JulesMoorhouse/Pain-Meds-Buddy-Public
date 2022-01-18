//
//  LocalisedStringTests.swift
//  PainMedsBuddyTests
//
//  Created by Jules Moorhouse.
//

// swiftlint:disable cyclomatic_complexity

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

        var output = ""

        print("--------")
        for item in Strings.allCases {
            switch item {
            case .commonBasicSettings:
                output = ""
            case .commonCancel:
                output = ""
            case .commonDelete:
                output = ""
            case .commonDosage:
                output = ""
            case .commonEgString:
                output = ""
            case .commonEmptyView:
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
            case .validationTwoLetters:
                output = ""
            case .validationOneOrAbove:
                output = ""
            case .validationMustSpecify:
                output = ""
            case .validationMustEmptySuffixS:
                output = ""
            case .titleHome:
                output = ""
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
            case .homeCurrentMeds:
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
                        .homeAccessibilityIconRemaining(med: med)

            case .homeAccessibilityIconTaken:
                output =
                    InterpolatedStrings
                        .homeAccessibilityIconTaken(dose: dose, med: med)

            case .homeAccessibilityIconTakeNow:
                output =
                    InterpolatedStrings
                        .homeAccessibilityIconTakeNow(med: med)

            case .homeAccessibilityAvailable:
                output = ""
            case .doseProgressAvailable:
                output = ""
            case .doseProgressUnknownMedication:
                output = ""
            case .doseProgressAccessibilityAvailable:
                output =
                    InterpolatedStrings
                        .doseProgressAccessibilityAvailable(dose: dose, med: med)

            case .doseProgressAccessibilityRemaining:
                output =
                    InterpolatedStrings
                        .doseProgressAccessibilityRemaining(dose: dose, med: med)

            case .selectMedSelectMed:
                output = ""
            case .doseEditAddDose:
                output = ""
            case .doseEditAreYouSure:
                output = ""
            case .doseEditAmount:
                output = ""
            case .doseEditDateTime:
                output = ""
            case .doseEditDeleteDose:
                output = ""
            case .doseEditDeleteThisDose:
                output = ""
            case .doseEditEditDose:
                output = ""
            case .doseEditMedication:
                output = ""
            case .sortOptimised:
                output = ""
            case .sortCreatedDate:
                output = ""
            case .sortSortOrder:
                output = ""
            case .sortTitle:
                output = ""
            case .medsMedications:
                output = ""
            case .medsSorryUsed:
                output = ""
            case .medsPleaseSelect:
                output = ""
            case .medEditTitleLabelAID:
                output = ""
            case .medEditTitleText:
                output = ""
            case .medEditGapInfo:
                output = ""
            case .medEditAddMed:
                output = ""
            case .medEditAreYouSure:
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
                        .medEditCopiedSuffix(title: "New Medication 1")

            case .medEditDefaultAmount:
                output = ""
            case .medEditDefaultText:
                output = ""
            case .medEditDeleteMed:
                output = ""
            case .medEditDeleteThisMed:
                output = ""
            case .medEditDurationGap:
                output = ""
            case .medEditDuration:
                output = ""
            case .medEditEditMed:
                output = ""
            case .medEditExampleDosage:
                output = ""
            case .medEditHiddenTitle:
                output = ""
            case .medEditForm:
                output = ""
            case .medEditImage:
                output = ""
            case .medEditInfo:
                output = ""
            case .medEditLowToast:
                output = ""
            case .medEditMeasure:
                output = ""
            case .medEditMg:
                output = ""
            case .medEditNewMedication:
                output = ""
            case .medEditNotes:
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
            case .settingsAcknowledgements:
                output = ""
            case .settingsAddExampleData:
                output = ""
            case .settingsDeleteAllData:
                output = ""
            }

            if !output.isEmpty {
                print("\(item.rawValue.stringKey): \(output)")
                print(" ")
            }
        }
        print("--------")
    }
}
