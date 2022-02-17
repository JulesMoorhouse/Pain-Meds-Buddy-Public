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
        _ = row.waitForExistence(timeout: 2)
        row.tap()

        let textField = app.textFields[Strings.doseEditAmount.automatedId()]
        _ = textField.waitForExistence(timeout: 2)

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
            Strings.homeAccessibilityIconRemainingEdit.automatedId()
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
    func testHomeHasTabSideBar() {
        BasicAction.tapTabHome(app)

        XCTAssertEqual(
            Elements.tabSideButtonCount(app),
            5,
            "There should be 5 tab bar or side bar buttons in the app."
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
            Elements.tabSideButtonCount(app),
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
            Elements.tabSideButtonCount(app),
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
            Elements.tabSideButtonCount(app),
            5,
            "There should be 5 tabs in the app."
        )
    }

    // ---- Home Route ---

    // ---- History Route ---
    func testHistoryHasTabSideBar() {
        BasicAction.tapTabHistory(app)

        XCTAssertEqual(
            Elements.tabSideButtonCount(app),
            5,
            "There should be 5 tabs in the app."
        )
    }

    func testHistoryAddDoseBackHasTabSideBar() {
        BasicAction.tapTabHistory(app)
        BasicAction.tapHistoryAddButton(app)

        let navBar = Elements.navBarAddDose(app)
        navBar.buttons[Strings.commonCancel.automatedId()].tap()

        // INFO: Confirm on history screen
        _ = Elements.navBarHistory(app)

        XCTAssertEqual(
            Elements.tabSideButtonCount(app),
            5,
            "There should be 5 tabs in the app."
        )
    }

    // ---- History Route ---

    // ---- In Progress Route ---
    func testInProgressHasTabSideBar() {
        BasicAction.tapTabInProgress(app)

        XCTAssertEqual(
            Elements.tabSideButtonCount(app),
            5,
            "There should be 5 tabs in the app."
        )
    }

    func testInProgressAddDoseBackHasTabSideBar() {
        BasicAction.tapTabInProgress(app)
        BasicAction.tapInProgressAddButton(app)

        let navBar = Elements.navBarAddDose(app)
        navBar.buttons[Strings.commonCancel.automatedId()].tap()

        // INFO: Confirm on in progress screen
        _ = Elements.navBarInProgress(app)

        XCTAssertEqual(
            Elements.tabSideButtonCount(app),
            5,
            "There should be 5 tabs in the app."
        )
    }

    // ---- In Progress Route ---

    // ---- Medication Route ---
    func testMedicationsHasTabSideBar() {
        BasicAction.tapTabMedications(app)

        XCTAssertEqual(
            Elements.tabSideButtonCount(app),
            5,
            "There should be 5 tabs in the app."
        )
    }

    func testMedicationsAddDoseBackHasTabSideBar() {
        BasicAction.tapTabMedications(app)
        BasicAction.tapMedicationTabAddButton(app)

        let navBar = Elements.navBarAddMed(app)
        navBar.buttons[Strings.commonCancel.automatedId()].tap()

        // INFO: Confirm on med screen
        _ = Elements.navBarMedications(app)

        XCTAssertEqual(
            Elements.tabSideButtonCount(app),
            5,
            "There should be 5 tabs in the app."
        )
    }

    // ---- Medication Route ---

    // ---- Settings Route ---
    func testSettingsHasTabSideBar() {
        BasicAction.tapTabSetting(app)

        XCTAssertEqual(
            Elements.tabSideButtonCount(app),
            5,
            "There should be 5 tabs in the app."
        )
    }
    // ---- Settings Route ---
}
