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
            tapAddMedBackButton()

            XCTAssertEqual(app.tables.cells.count, addCount, "There should be \(addCount) list rows initially.")
        }
    }

    func testAddDose() {
        tapTabMedications()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        tapMedicationTabAddButton()
        tapAddMedBackButton()

        tapTabInProgress()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        tapInProgressAddButton()
        tapAddDoseBackButton()

        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list rows initially.")
    }

    func testEmptyDoses() {

        let homeScreen = app.buttons["Home"]
        XCTAssertTrue(homeScreen.exists)

        let someView = app.staticTexts["commonEmptyView"]
        XCTAssertTrue(someView.exists)
    }

    // These helper methods should not have any parameters and should perform simple actions
    // and confirm the action occurred

    func tapTabMedications() {
        app.buttons["Medications"].tap()
        _ = app.navigationBars["Medications"].waitForExistence(timeout: 10)
    }

    func tapTabInProgress() {
        app.buttons["In Progress"].tap()
        _ = app.navigationBars["In Progress"].waitForExistence(timeout: 10)
    }

    func tapMedicationTabAddButton() {
        let medicationScreen = app.navigationBars["Medications"]
        medicationScreen.buttons["add"].tap()
        _ = app.navigationBars["Add Med"].waitForExistence(timeout: 10)
    }

    func tapAddMedBackButton() {
        let addMedScreen = app.navigationBars["Add Med"]
        addMedScreen.buttons["Medications"].tap()
        _ = app.navigationBars["Medications"].waitForExistence(timeout: 10)
    }

    func tapInProgressAddButton() {
        let doseScreen = app.navigationBars["In Progress"]
        doseScreen.buttons["add"].tap()
        _ = app.navigationBars["Add Dose"].waitForExistence(timeout: 10)
    }

    func tapAddDoseBackButton() {
        let addDoseScreen = app.navigationBars["Add Dose"]
        addDoseScreen.buttons["In Progress"].tap()
        _ = app.navigationBars["In progress"].waitForExistence(timeout: 10)
    }
}
