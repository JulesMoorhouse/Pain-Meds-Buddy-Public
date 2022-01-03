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
            _ = Elements.navBarMedications(app)

            let rowCount = app.tables.cells.count

            // Then
            XCTAssertEqual(
                rowCount,
                addCount,
                "There should be \(addCount) list rows initially.")
        }
    }

    func testAddDose() {
        // Given - One medication is required
        BasicAction.tapTabMedications(app)

        XCTAssertEqual(
            app.tables.cells.count,
            0,
            "There should be no list rows initially.")

        // When
        BasicAction.tapMedicationTabAddButton(app)

        // Back button tap on add med screen
        BasicAction.tapBackButton(app)

        // Confirm on medications screen
        _ = Elements.navBarMedications(app)

        BasicAction.tapTabInProgress(app)

        // Then
        XCTAssertEqual(
            app.tables.cells.count,
            0,
            "There should be no list rows initially.")

        // Add a basic dose
        BasicAction.tapInProgressAddButton(app)

        // Back button tap on add dose screen
        BasicAction.tapBackButton(app)

        // Confirm on in progress screen
        _ = Elements.navBarInProgress(app)

        let rowCount = app.tables.cells.count

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
        _ = Elements.navBarHome(app)

        let labelId = Strings.commonEmptyView.automatedId()
        let someView = app.staticTexts[labelId]

        // Then
        XCTAssertTrue(
            someView.exists,
            "Home empty placeholder label not showing")
    }

    func testMedsHasSort() {
        // Given
        BasicAction.tapTabMedications(app)

        XCTAssertEqual(
            app.tables.cells.count,
            0,
            "There should be no list rows initially.")

        // When
        BasicAction.tapMedicationTabAddButton(app)

        // Back button tap on add med screen
        BasicAction.tapBackButton(app)

        // Confirm on meds screen
        let navBar = Elements.navBarMedications(app)

        let sortButton = navBar.buttons[Strings.commonSort.automatedId()]

        // Then
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

    func testSettingsHasAcknowledgements() {}

    func testAddDoseDetails() {}

    func testAddMedDetails() {}

    func testHomeHasProgress() {}

    func testHomeHasLowMeds() {}

    func testHomeHasRecentMeds() {}
}
