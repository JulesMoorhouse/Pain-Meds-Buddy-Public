//
//  PainMedsBuddyUITests.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import XCTest

class PainMedsBuddyUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["enable-ui-testing"]
        app.launch()
    }

    func testAppHas5Tabs() throws {
        XCTAssertEqual(
            app.tabBars.buttons.count,
            5,
            "There should be 5 tabs in the app.")
    }

    func testAddFiveMedications() {
        // Given
        BasicAction.tapTabMedications(app)

        XCTAssertEqual(
            app.tables.cells.count,
            0,
            "There should be no list rows initially.")

        for addCount in 1 ... 5 {
            // When
            BasicAction.tapMedicationTabAddButton(app)

            // Back button tap on add med screen
            BasicAction.tapBackButton(app)

            // Confirm on medications screen
            _ = Elements.navBarMedications(app, performTest:  false)

            let rowCount = app.tables.cells.count

            // Then
            XCTAssertEqual(
                rowCount,
                addCount,
                "There should be \(addCount) list rows initially.")
        }
    }

    func testAddDose() {
        // --- Should use datafile or data generation / not part of test ---
        // Given - One medication is required
        BasicAction.tapTabMedications(app)
        BasicAction.tapMedicationTabAddButton(app)
        BasicAction.tapBackButton(app)
        _ = Elements.navBarMedications(app, performTest: false)
        BasicAction.tapTabInProgress(app)
        // --- Should use datafile or data generation / not part of test ---

        // Given
        // Add a basic dose
        BasicAction.tapInProgressAddButton(app)

        // Back button tap on add dose screen
        BasicAction.tapBackButton(app)

        // Confirm on in progress screen
        _ = Elements.navBarInProgress(app, performTest: false)

        // When
        let rowCount = app.tables.cells.count

        // Then
        XCTAssertEqual(
            rowCount,
            1,
            "There should be 1 list rows initially.")
    }

    func testEmptyHistory() {
        // Given
        BasicAction.tapTabHistory(app)

        // When - Confirm on history screen
        _ = Elements.navBarHistory(app)

        let labelId = Strings.commonPleaseAdd.automatedId()
        let someView = app.staticTexts[labelId]

        // Then
        XCTAssertTrue(
            someView.exists,
            "History empty placeholder label not showing")
    }

    func testEmptyInProgress() {
        // Given
        BasicAction.tapTabInProgress(app)

        // When - Confirm on in progress screen
        _ = Elements.navBarInProgress(app)

        let labelId = Strings.commonPleaseAdd.automatedId()
        let someView = app.staticTexts[labelId]

        // Then
        XCTAssertTrue(
            someView.exists,
            "In Progress empty placeholder label not showing")
    }

    func testEmptyMeds() {
        // Given
        BasicAction.tapTabMedications(app)

        // When - Confirm on meds screen
        _ = Elements.navBarMedications(app)

        let labelId = Strings.commonEmptyView.automatedId()
        let someView = app.staticTexts[labelId]

        // Then
        XCTAssertTrue(
            someView.exists,
            "Medications empty placeholder label not showing")
    }

    func testEmptyHome() {
        // When - Confirm on home screen
        BasicAction.tapTabHome(app)
        _ = Elements.navBarHome(app, performTest: false)

        let labelId = Strings.commonEmptyView.automatedId()
        let someView = app.staticTexts[labelId]

        // Then
        XCTAssertTrue(
            someView.exists,
            "Home empty placeholder label not showing")
    }

    func testMedsHasSort() {
        // --- Should use datafile or data generation / not part of test ---
        BasicAction.tapTabMedications(app)
        BasicAction.tapMedicationTabAddButton(app)
        BasicAction.tapBackButton(app)
        // --- Should use datafile or data generation / not part of test ---

        let sortButton = app.buttons[Strings.commonSort.automatedId()]

        XCTAssertTrue(
            sortButton.exists,
            "Medications sort button not found")
    }

    func testMedsHasAdd() {
        // Given
        BasicAction.tapTabMedications(app)

        XCTAssertEqual(
            app.tables.cells.count,
            0,
            "There should be no list rows initially.")

        // When
        let navBar = Elements.navBarMedications(app)
        let button = navBar.buttons[Strings.medEditAddMed.automatedId()]

        // Then
        XCTAssertTrue(
            button.exists,
            "Medications add button not found")
    }

    func testSettingsHasAcknowledgements() {
        // Given
        BasicAction.tapTabSetting(app)

        let ackButton = app.buttons[Strings.settingsAcknowledgements.automatedId()]

        // Then
        XCTAssertTrue(
            ackButton.exists,
            "Settings acknowledgements button not found")
    }

    func testEditDose() {
        // --- Should use datafile or data generation / not part of test ---
        BasicAction.tapTabMedications(app)
        BasicAction.tapMedicationTabAddButton(app)
        BasicAction.tapBackButton(app)
        _ = Elements.navBarMedications(app, performTest: false)
        BasicAction.tapTabInProgress(app)
        BasicAction.tapInProgressAddButton(app)
        BasicAction.tapBackButton(app)
        // --- Should use datafile or data generation / not part of test ---

        // Given
        // tap newly added item on dose list
        app.buttons[Strings.homeAccessibilityIconTaken.automatedId()].tap()

        let textField = app.textFields[Strings.doseEditAmount.automatedId()]
        textField.doubleTap()
        textField.clearText()
        
        // When
        app.keys["2"].tap()
        app.keys["9"].tap()

        BasicAction.tapBackButton(app)

        // Then
        let predicate = NSPredicate(format: "label CONTAINS '29'")
        let element = app.buttons.element(matching: predicate)

        XCTAssertTrue(element.exists, "The edited dose should be visible in the list.")
    }

    func testEditMed() {
        // --- Should use datafile or data generation / not part of test ---
        BasicAction.tapTabMedications(app)
        BasicAction.tapMedicationTabAddButton(app)
        BasicAction.tapBackButton(app)
        // --- Should use datafile or data generation / not part of test ---

        // Given
        // tap newly added item on medications list
        app.buttons[Strings.homeAccessibilityIconRemaining.automatedId()].tap()

        app.textFields[Strings.medEditTitleText.automatedId()].tap()

        // When
        app.keys["space"].tap()
        
        if UIDevice.current.userInterfaceIdiom != .pad {
            app.keys["more"].tap()
        }
        app.keys["2"].tap()
        app.buttons["Return"].tap()

        BasicAction.tapBackButton(app)

        // Then
        let predicate = NSPredicate(format: "label CONTAINS 'New Medication 2'")
        let element = app.buttons.element(matching: predicate)

        XCTAssertTrue(element.exists, "The edited medication should be visible in the list.")
    }

    func testHomeHasProgress() {
        // --- Should use datafile or data generation / not part of test ---
        BasicAction.tapTabMedications(app)
        BasicAction.tapMedicationTabAddButton(app)
        BasicAction.tapBackButton(app)
        _ = Elements.navBarMedications(app, performTest: false)
        BasicAction.tapTabInProgress(app)
        BasicAction.tapInProgressAddButton(app)
        BasicAction.tapBackButton(app)
        BasicAction.tapTabHome(app)
        // --- Should use datafile or data generation / not part of test ---

        let section = app.otherElements[Strings.homeCurrentMeds.automatedId()]

        XCTAssertTrue(
            section.exists,
            "Home current meds section not showing")
    }

    func testHomeHasLowMeds() {
        // --- Should use datafile or data generation / not part of test ---
        BasicAction.tapTabMedications(app)
        BasicAction.tapMedicationTabAddButton(app)
        BasicAction.tapBackButton(app)
        _ = Elements.navBarMedications(app, performTest: false)
        BasicAction.tapTabHome(app)
        // --- Should use datafile or data generation / not part of test ---

        let section = app.otherElements[Strings.homeMedsRunningOut.automatedId()]

        XCTAssertTrue(
            section.exists,
            "Home low meds section not showing")
    }

    func testHomeHasRecentMeds() {
        // --- Should use datafile or data generation / not part of test ---
        BasicAction.tapTabMedications(app)
        BasicAction.tapMedicationTabAddButton(app)
        BasicAction.tapBackButton(app)
        _ = Elements.navBarMedications(app, performTest: false)
        BasicAction.tapTabHome(app)
        // --- Should use datafile or data generation / not part of test ---

        let section = app.otherElements[Strings.homeRecentlyTaken.automatedId()]

        XCTAssertTrue(
            section.exists,
            "Home recent meds section not showing")
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
}
