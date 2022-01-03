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
        XCTAssertEqual(app.tabBars.buttons.count, 5, "There should be 5 tabs in the app.")
    }

    func testAddMedication() {
        tapTabMedications()

        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        for addCount in 1 ... 5 {
            tapMedicationTabAddButton()
            tapBackButton()
            _ = Elements.navBarMedications(app) // Confirm on medications screen

            let rowCount = app.tables.cells.count
            XCTAssertEqual(rowCount, addCount, "There should be \(addCount) list rows initially.")
        }
    }

    func testAddDose() {
        tapTabMedications()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        tapMedicationTabAddButton()
        tapBackButton()
        _ = Elements.navBarMedications(app) // Confirm on medications screen

        tapTabInProgress()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        tapInProgressAddButton()
        tapBackButton()
        _ = Elements.navBarInProgress(app) // Confirm on medications screen

        let rowCount = app.tables.cells.count
        XCTAssertEqual(rowCount, 1, "There should be 1 list rows initially.")
    }

    func testEmptyDoses() {
        let homeScreen: XCUIElement = app.buttons["Home"]
        XCTAssertTrue(homeScreen.exists)

        let someView = app.staticTexts["commonEmptyView"]
        XCTAssertTrue(someView.exists)
    }

    func tapBackButton() {
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }

    func tapTabMedications() {
        let tab = Elements.tabMedications(app)
        tab.tap()
        _ = app.navigationBars["Medications"].waitForExistence(timeout: 2)
    }

    func tapTabInProgress() {
        let tab = Elements.tabInProgress(app)
        tab.tap()
        _ = app.navigationBars["In Progress"].waitForExistence(timeout: 2)
    }

    func tapMedicationTabAddButton() {
        let navBar = Elements.navBarMedications(app)
        navBar.buttons["add"].tap()
        _ = app.navigationBars["Add Med"].waitForExistence(timeout: 2)
    }

    func tapInProgressAddButton() {
        let navBar = Elements.navBarInProgress(app)
        navBar.buttons["add"].tap()
        _ = app.navigationBars["Add Dose"].waitForExistence(timeout: 2)
    }
}
