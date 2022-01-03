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
        tapTabMedications()

        XCTAssertEqual(
            app.tables.cells.count,
            0,
            "There should be no list rows initially.")

        for addCount in 1 ... 5 {
            tapMedicationTabAddButton()

            // Back button tap on add med screen
            tapBackButton()

            // Confirm on medications screen
            _ = Elements.navBarMedications(app)

            let rowCount = app.tables.cells.count

            XCTAssertEqual(
                rowCount,
                addCount,
                "There should be \(addCount) list rows initially.")
        }
    }

    func testAddDose() {
        // One medication is required
        tapTabMedications()

        XCTAssertEqual(
            app.tables.cells.count,
            0,
            "There should be no list rows initially.")

        tapMedicationTabAddButton()

        // Back button tap on add med screen
        tapBackButton()

        // Confirm on medications screen
        _ = Elements.navBarMedications(app)

        tapTabInProgress()

        XCTAssertEqual(
            app.tables.cells.count,
            0,
            "There should be no list rows initially.")

        // Add a basic dose
        tapInProgressAddButton()

        // Back button tap on add dose screen
        tapBackButton()

        // Confirm on in progress screen
        _ = Elements.navBarInProgress(app)

        let rowCount = app.tables.cells.count

        XCTAssertEqual(
            rowCount,
            1,
            "There should be 1 list rows initially.")
    }

    func testEmptyHistory() {
        tapTabHistory()

        // Confirm on history screen
        _ = Elements.navBarHistory(app)

        let labelId = Strings.commonPleaseAdd.automatedId()
        let someView = app.staticTexts[labelId]

        XCTAssertTrue(
            someView.exists,
            "History empty placeholder label not showing")
    }

    func testEmptyInProgress() {
        tapTabInProgress()

        // Confirm on in progress screen
        _ = Elements.navBarInProgress(app)

        let labelId = Strings.commonPleaseAdd.automatedId()
        let someView = app.staticTexts[labelId]

        XCTAssertTrue(
            someView.exists,
            "In Progress empty placeholder label not showing")
    }

    func testEmptyMeds() {
        tapTabMedications()

        // Confirm on meds screen
        _ = Elements.navBarMedications(app)

        let labelId = Strings.commonEmptyView.automatedId()
        let someView = app.staticTexts[labelId]

        XCTAssertTrue(
            someView.exists,
            "Medications empty placeholder label not showing")
    }

    func testEmptyHome() {
        // Confirm on home screen
        _ = Elements.navBarHome(app)

        let labelId = Strings.commonEmptyView.automatedId()
        let someView = app.staticTexts[labelId]

        XCTAssertTrue(
            someView.exists,
            "Home empty placeholder label not showing")
    }

    func testMedsHasSort() {
        tapTabMedications()

        XCTAssertEqual(
            app.tables.cells.count,
            0,
            "There should be no list rows initially.")

        tapMedicationTabAddButton()

        // Back button tap on add med screen
        tapBackButton()

        // Confirm on meds screen
        let navBar = Elements.navBarMedications(app)

        let sortButton = navBar.buttons[Strings.commonSort.automatedId()]

        XCTAssertTrue(
            sortButton.exists,
            "Medications sort button not found")
    }

    func testMedsHasAdd() {}

    func testSettingsHasAcknowledgements() {}

    func testAddDoseDetails() {}

    func testAddMedDetails() {}

    func testHomeHasProgress() {}

    func testHomeHasLowMeds() {}

    func testHomeHasRecentMeds() {}

    func tapBackButton() {
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }

    func tapTabHome() {
        let tab = Elements.tabHome(app)
        tab.tap()

        // Confirm on home screen
        _ = Elements.navBarHome(app)
    }

    func tapTabHistory() {
        let tab = Elements.tabHistory(app)
        tab.tap()

        // Confirm on in history screen
        _ = Elements.navBarHistory(app)
    }

    func tapTabInProgress() {
        let tab = Elements.tabInProgress(app)
        tab.tap()

        // Confirm on in progress screen
        _ = Elements.navBarInProgress(app)
    }

    func tapTabMedications() {
        let tab = Elements.tabMedications(app)
        tab.tap()

        // Confirm on medications screen
        _ = Elements.navBarMedications(app)
    }

    func tapMedicationTabAddButton() {
        let navBar = Elements.navBarMedications(app)
        navBar.buttons[Strings.medEditAddMed.automatedId()].tap()

        // Confirm on add med screen
        _ = Elements.navBarAddMed(app)
    }

    func tapInProgressAddButton() {
        let navBar = Elements.navBarInProgress(app)
        navBar.buttons[Strings.doseEditAddDose.automatedId()].tap()

        // Confirm on add dose screen
        _ = Elements.navBarAddDose(app)
    }
}
