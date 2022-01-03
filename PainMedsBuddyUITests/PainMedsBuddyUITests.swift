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
        tapBackButton()

        // Confirm on in progress screen
        _ = Elements.navBarInProgress(app)

        let rowCount = app.tables.cells.count

        XCTAssertEqual(
            rowCount,
            1,
            "There should be 1 list rows initially.")
    }

    func testEmptyDoses() {
        // Confirm on home screen
        _ = Elements.navBarHome(app)

        let labelId = Strings.commonEmptyView.automatedId()
        let someView = app.staticTexts[labelId]

        XCTAssertTrue(someView.exists)
    }

    func tapBackButton() {
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }

    func tapTabMedications() {
        let tab = Elements.tabMedications(app)
        tab.tap()

        // Confirm on medications screen
        _ = Elements.navBarMedications(app)
    }

    func tapTabInProgress() {
        let tab = Elements.tabInProgress(app)
        tab.tap()

        // Confirm on in progress screen
        _ = Elements.navBarInProgress(app)
    }

    func tapMedicationTabAddButton() {
        let navBar = Elements.navBarMedications(app)
        navBar.buttons["add"].tap()

        // Confirm on add med screen
        _ = Elements.navBarAddMed(app)
    }

    func tapInProgressAddButton() {
        let navBar = Elements.navBarInProgress(app)
        navBar.buttons["add"].tap()

        // Confirm on add dose screen
        _ = Elements.navBarAddDose(app)
    }
}
