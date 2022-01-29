//
//  PainMedsBuddyUITests.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import XCTest

class ExistingDataTests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["enable-ui-testing", "[5,5]"]
        app.launch()
    }

    func testMedsHasSort() {
        BasicAction.tapTabMedications(app)

        let sortButton = app.buttons[Strings.commonSort.automatedId()]

        XCTAssertTrue(
            sortButton.exists,
            "Medications sort button not found"
        )
    }

    func testEditDose() {
        // Given
        BasicAction.tapTabInProgress(app)

        let row = app.buttons[
            Strings.homeAccessibilityIconTaken.automatedId()
        ].firstMatch
        _ = row.waitForExistence(timeout: 1)
        row.tap()

        let textField = app.textFields[Strings.doseEditAmount.automatedId()]
        _ = textField.waitForExistence(timeout: 1)

        textField.doubleTap()
        textField.clearText()

        // When
        app.keys["2"].tap()
        app.keys["9"].tap()

        BasicAction.tapEditDoseSaveButton(app)

        // Then
        let predicate = NSPredicate(format: "label CONTAINS '29'")
        let element = app.buttons.element(matching: predicate)

        XCTAssertTrue(element.exists, "The edited dose should be visible in the list.")
    }

    func testHomeHasProgress() {
        BasicAction.tapTabHome(app)

        let section = app.otherElements[Strings.homeCurrentMeds.automatedId()]

        XCTAssertTrue(
            section.exists,
            "Home current meds section not showing"
        )
    }

    func testHomeHasLowMeds() {
        BasicAction.tapTabHome(app)

        app.swipeUp()

        let row = app.buttons[
            Strings.homeAccessibilityIconRemaining.automatedId()
        ].firstMatch

        XCTAssertTrue(
            row.exists,
            "Home low meds row not showing"
        )
    }

    func testHomeHasRecentMeds() {
        BasicAction.tapTabHome(app)

        let row = app.buttons[
            Strings.homeAccessibilityIconTakeNow.automatedId()
        ].firstMatch

        _ = row.waitForExistence(timeout: 2)

        XCTAssertTrue(
            row.exists,
            "Home recent meds section not showing"
        )
    }

    func TODO_testSortOrder() {
        // To Do
        // test sort order popup shows and changes sort order of items
        // do on med select and meds view
    }

    func TODO_testMedSelection() {
        // To Do
    }

    func TODO_testHomeProgressAvailable() {
        // To Do
        // test that the home progress circles, once available
        // disappear after a set period
    }

    func TODO_testHomeLowMedsAreCorrect() {
        // To Do
        // test that only low meds are show at the set low value
    }

    func TODO_testHomeLowMedsShowEditedValues() {
        // To Do
    }

    func TODO_testHomeRecentMedsShowEditedValues() {
        // To Do
    }

    func TODO_testHomeInProgressDosesShowEditedValues() {
        // To Do
    }

    func TODO_testMedDeleteFromEditScreen() {
        // To Do
    }

    func TODO_testMedDeleteFromListScreen() {
        // To Do
    }

    func TODO_testDoseDeleteFromEditScreen() {
        // To Do
    }

    func TODO_testDoseDeleteFromListScreen() {
        // To Do
    }

    func TODO_testMedSortTitle() {
        // To Do
    }

    // ---- Home Route ---
    func testHomeHasTabBar() {
        BasicAction.tapTabHome(app)

        XCTAssertEqual(
            app.tabBars.buttons.count,
            5,
            "There should be 5 tabs in the app."
        )
    }

    func homeProgressAddDoseBackHasTabBar() {
        BasicAction.tapTabHome(app)
        let nextButton = app.buttons[Strings.doseProgressAccessibilityCloseButton.automatedId()]
        nextButton.tap()

        // INFO: Confirm on add dose screen
        _ = Elements.navBarAddDose(app)

        let navBar = Elements.navBarAddDose(app)
        navBar.buttons[Strings.commonCancel.automatedId()].tap()

        // INFO: Confirm on home screen
        _ = Elements.navBarHome(app)

        XCTAssertEqual(
            app.tabBars.buttons.count,
            5,
            "There should be 5 tabs in the app."
        )
    }

    func homeRecentAddDoseBackHasTabBar() {
        BasicAction.tapTabHome(app)

        let row = app.buttons[
            Strings.homeAccessibilityIconTakeNow.automatedId()
        ].firstMatch

        _ = row.waitForExistence(timeout: 2)

        row.tap()

        let navBar = Elements.navBarEditDose(app)
        navBar.buttons[Strings.commonCancel.automatedId()].tap()

        // INFO: Confirm on home screen
        _ = Elements.navBarHome(app)

        XCTAssertEqual(
            app.tabBars.buttons.count,
            5,
            "There should be 5 tabs in the app."
        )
    }

    func homeLowEditDoseBackHasTabBar() {
        BasicAction.tapTabHome(app)

        app.swipeUp()

        let row = app.buttons[
            Strings.homeAccessibilityIconRemaining.automatedId()
        ].firstMatch

        _ = row.waitForExistence(timeout: 2)

        row.tap()

        let navBar = Elements.navBarEditDose(app)
        navBar.buttons[Strings.commonCancel.automatedId()].tap()

        // INFO: Confirm on home screen
        _ = Elements.navBarHome(app)

        XCTAssertEqual(
            app.tabBars.buttons.count,
            5,
            "There should be 5 tabs in the app."
        )
    }

    // ---- Home Route ---

    // ---- History Route ---
    func testHistoryHasTabBar() {
        BasicAction.tapTabHistory(app)

        XCTAssertEqual(
            app.tabBars.buttons.count,
            5,
            "There should be 5 tabs in the app."
        )
    }

    func testHistoryAddDoseBackHasTabBar() {
        BasicAction.tapTabHistory(app)
        BasicAction.tapHistoryAddButton(app)

        let navBar = Elements.navBarAddDose(app)
        navBar.buttons[Strings.commonCancel.automatedId()].tap()

        // INFO: Confirm on history screen
        _ = Elements.navBarHistory(app)

        XCTAssertEqual(
            app.tabBars.buttons.count,
            5,
            "There should be 5 tabs in the app."
        )
    }

    // ---- History Route ---

    // ---- In Progress Route ---
    func testInProgressHasTabBar() {
        BasicAction.tapTabInProgress(app)

        XCTAssertEqual(
            app.tabBars.buttons.count,
            5,
            "There should be 5 tabs in the app."
        )
    }

    func testInProgressAddDoseBackHasTabBar() {
        BasicAction.tapTabInProgress(app)
        BasicAction.tapInProgressAddButton(app)

        let navBar = Elements.navBarAddDose(app)
        navBar.buttons[Strings.commonCancel.automatedId()].tap()

        // INFO: Confirm on in progress screen
        _ = Elements.navBarInProgress(app)

        XCTAssertEqual(
            app.tabBars.buttons.count,
            5,
            "There should be 5 tabs in the app."
        )
    }

    // ---- In Progress Route ---

    // ---- Medication Route ---
    func testMedicationsHasTabBar() {
        BasicAction.tapTabMedications(app)

        XCTAssertEqual(
            app.tabBars.buttons.count,
            5,
            "There should be 5 tabs in the app."
        )
    }

    func testMedicationsAddDoseBackHasTabBar() {
        BasicAction.tapTabMedications(app)
        BasicAction.tapMedicationTabAddButton(app)

        let navBar = Elements.navBarAddMed(app)
        navBar.buttons[Strings.commonCancel.automatedId()].tap()

        // INFO: Confirm on med screen
        _ = Elements.navBarMedications(app)

        XCTAssertEqual(
            app.tabBars.buttons.count,
            5,
            "There should be 5 tabs in the app."
        )
    }

    // ---- Medication Route ---

    // ---- Settings Route ---
    func testSettingsHasTabBar() {
        BasicAction.tapTabSetting(app)

        XCTAssertEqual(
            app.tabBars.buttons.count,
            5,
            "There should be 5 tabs in the app."
        )
    }

    // ---- Settings Route ---

    // ---- Sub View Routes ---
    func testAddDoseHasNoTabBar() {
        BasicAction.tapTabInProgress(app)
        BasicAction.tapInProgressAddButton(app)

        XCTAssertEqual(
            app.tabBars.buttons.count,
            0,
            "There should be 0 tabs in the app."
        )
    }

    func testAddMedHasNoTabBar() {
        BasicAction.tapTabMedications(app)
        BasicAction.tapMedicationTabAddButton(app)

        XCTAssertEqual(
            app.tabBars.buttons.count,
            0,
            "There should be 0 tabs in the app."
        )
    }

    func testSelectMedHasNoTabBar() {
        BasicAction.tapTabInProgress(app)
        BasicAction.tapInProgressAddButton(app)

        let row = app.buttons[Strings.doseEditMedication.automatedId()]
        row.tap()

        // INFO: Confirm on med select screen
        _ = Elements.navBarMedSelect(app)

        XCTAssertEqual(
            app.tabBars.buttons.count,
            0,
            "There should be 0 tabs in the app."
        )
    }

    func testSettingsAdvancedHasNoTabBar() {
        BasicAction.tapTabSetting(app)

        // INFO: Confirm on settings screen
        _ = Elements.navBarSettings(app)

        let button = app.buttons[Strings.settingsAdvanced.automatedId()]
        button.tap()

        // INFO: Confirm on settings screen
        _ = Elements.navBarSettingsAdvanced(app)

        XCTAssertEqual(
            app.tabBars.buttons.count,
            0,
            "There should be 0 tabs in the app."
        )
    }

    func testSettingsDeveloperOptionsHasNoTabBar() {
        BasicAction.tapTabSetting(app)

        // INFO: Confirm on settings screen
        _ = Elements.navBarSettings(app)

        let button = app.buttons[Strings.settingsDeveloper.automatedId()]
        button.tap()

        // INFO: Confirm on settings screen
        _ = Elements.navBarSettingsDeveloper(app)

        XCTAssertEqual(
            app.tabBars.buttons.count,
            0,
            "There should be 0 tabs in the app."
        )
    }

    func testSettingsAcknowledgementsHasNoTabBar() {
        BasicAction.tapTabSetting(app)

        // INFO: Confirm on settings screen
        _ = Elements.navBarSettings(app)

        let button = app.buttons[Strings.settingsAcknowledgements.automatedId()]
        button.tap()

        // INFO: Confirm on settings screen
        _ = Elements.navBarSettingsAcknowledgements(app)

        XCTAssertEqual(
            app.tabBars.buttons.count,
            0,
            "There should be 0 tabs in the app."
        )
    }
    // ---- Sub View Routes ---
}
