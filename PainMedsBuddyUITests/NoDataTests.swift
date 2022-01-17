//
//  NoDataTests.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import XCTest

class NoDataUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["wipe-data"]
        app.launch()
    }

    func testAppHas5Tabs() throws {
        XCTAssertEqual(
            app.tabBars.buttons.count,
            5,
            "There should be 5 tabs in the app."
        )
    }

    func testAddFiveMedications() {
        // Given
        BasicAction.tapTabMedications(app)

        XCTAssertEqual(
            app.tables.cells.count,
            0,
            "There should be no list rows initially."
        )

        for addCount in 1 ... 5 {
            // When
            BasicAction.tapMedicationTabAddButton(app)

            // Add details
            // xxx

            // Save button tap on add med screen
            BasicAction.tapAddDoseSaveButton(app)

            // Confirm on medications screen
            _ = Elements.navBarMedications(app, performTest: false)

            let rowCount = app.tables.cells.count

            // Then
            XCTAssertEqual(
                rowCount,
                addCount,
                "There should be \(addCount) list rows initially."
            )
        }
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
            "History empty placeholder label not showing"
        )
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
            "In Progress empty placeholder label not showing"
        )
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
            "Medications empty placeholder label not showing"
        )
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
            "Home empty placeholder label not showing"
        )
    }

    func testMedsHasAdd() {
        // Given
        BasicAction.tapTabMedications(app)

        XCTAssertEqual(
            app.tables.cells.count,
            0,
            "There should be no list rows initially."
        )

        // When
        let navBar = Elements.navBarMedications(app)
        let button = navBar.buttons[Strings.medEditAddMed.automatedId()]

        // Then
        XCTAssertTrue(
            button.exists,
            "Medications add button not found"
        )
    }

    func testSettingsHasAcknowledgements() {
        // Given
        BasicAction.tapTabSetting(app)

        let ackButton = app.buttons[Strings.settingsAcknowledgements.automatedId()]

        // Then
        XCTAssertTrue(
            ackButton.exists,
            "Settings acknowledgements button not found"
        )
    }
}
