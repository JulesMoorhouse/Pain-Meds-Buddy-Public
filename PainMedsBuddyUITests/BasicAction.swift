//
//  BasicAction.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import XCTest

class BasicAction: XCTestCase {
    static func tapBackButton(_ app: XCUIApplication) {
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }

    // ---- tab bar items ----
    static func tapTabHome(_ app: XCUIApplication) {
        let tab = Elements.tabHome(app)
        tab.tap()

        // Confirm on home screen
        _ = Elements.navBarHome(app)
    }

    static func tapTabHistory(_ app: XCUIApplication) {
        let tab = Elements.tabHistory(app)
        tab.tap()

        // Confirm on in history screen
        _ = Elements.navBarHistory(app)
    }

    static func tapTabInProgress(_ app: XCUIApplication) {
        let tab = Elements.tabInProgress(app)
        tab.tap()

        // Confirm on in progress screen
        _ = Elements.navBarInProgress(app)
    }

    static func tapTabMedications(_ app: XCUIApplication) {
        let tab = Elements.tabMedications(app)
        tab.tap()

        // Confirm on medications screen
        _ = Elements.navBarMedications(app)
    }

    static func tapTabSetting(_ app: XCUIApplication) {
        let tab = Elements.tabSettings(app)
        tab.tap()

        // Confirm on settings screen
        _ = Elements.navBarSettings(app)
    }

    // ---- tab bar items ----

    static func tapMedicationTabAddButton(_ app: XCUIApplication) {
        app.buttons[Strings.medEditAddMed.automatedId()].tap()

        // Confirm on add med screen
        _ = Elements.navBarAddMed(app)
    }

    static func tapInProgressAddButton(_ app: XCUIApplication) {
        let navBar = Elements.navBarInProgress(app)
        navBar.buttons[Strings.doseEditAddDose.automatedId()].tap()

        // Confirm on add dose screen
        _ = Elements.navBarAddDose(app)
    }

    static func tapHistorysAddButton(_ app: XCUIApplication) {
        let navBar = Elements.navBarHistory(app)
        navBar.buttons[Strings.doseEditAddDose.automatedId()].tap()

        // Confirm on add dose screen
        _ = Elements.navBarAddDose(app)
    }

    static func tapAddDoseSaveButton(_ app: XCUIApplication) {
        let navBar = Elements.navBarAddDose(app)
        navBar.buttons[Strings.commonSave.automatedId()].tap()

        // Confirm on add dose screen
        _ = Elements.navBarInProgress(app)
    }

    static func tapEditDoseSaveButton(_ app: XCUIApplication) {
        let navBar = Elements.navBarEditDose(app)
        navBar.buttons[Strings.commonSave.automatedId()].tap()

        // Confirm on add dose screen
        _ = Elements.navBarInProgress(app)
    }

    static func tapEditDoseCancelButton(_ app: XCUIApplication) {
        let navBar = Elements.navBarEditMed(app)
        navBar.buttons[Strings.commonCancel.automatedId()].tap()

        // Confirm on add dose screen
        _ = Elements.navBarInProgress(app)
    }

    static func tapEditMedSaveButton(_ app: XCUIApplication) {
        let navBar = Elements.navBarEditMed(app)
        navBar.buttons[Strings.commonSave.automatedId()].tap()

        // Confirm on add dose screen
        _ = Elements.navBarMedications(app)
    }

    static func tapAddMedSaveButton(_ app: XCUIApplication) {
        let navBar = Elements.navBarAddMed(app)
        navBar.buttons[Strings.commonSave.automatedId()].tap()

        // Confirm on add dose screen
        _ = Elements.navBarMedications(app)
    }

    static func tapEditMedCancelButton(_ app: XCUIApplication) {
        let navBar = Elements.navBarEditMed(app)
        navBar.buttons[Strings.commonCancel.automatedId()].tap()

        // Confirm on add dose screen
        _ = Elements.navBarMedications(app)
    }

    static func tapAddMedCancelButton(_ app: XCUIApplication) {
        let navBar = Elements.navBarAddMed(app)
        navBar.buttons[Strings.commonCancel.automatedId()].tap()

        // Confirm on add dose screen
        _ = Elements.navBarMedications(app)
    }
}
