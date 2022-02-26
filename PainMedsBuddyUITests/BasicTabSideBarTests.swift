//
//  BasicTabSideBarTests.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import XCTest

class BasicTabSideBarTests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["enable-ui-testing", "[5,5]"]
        app.launch()
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
