//
//  Elements.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import XCTest

class Elements: XCTestCase {
    // These helper methods should not have any parameters and should perform simple actions
    // and confirm the action occurred

    // ---- Tabs ----
    static func tabHome(_ app: XCUIApplication) -> XCUIElement {
        app.tabBars.buttons.element(boundBy: 0)
    }

    static func tabHistory(_ app: XCUIApplication) -> XCUIElement {
        app.tabBars.buttons.element(boundBy: 1)
    }

    static func tabInProgress(_ app: XCUIApplication) -> XCUIElement {
        app.tabBars.buttons.element(boundBy: 2)
    }

    static func tabMedications(_ app: XCUIApplication) -> XCUIElement {
        app.tabBars.buttons.element(boundBy: 3)
    }

    static func tabSettings(_ app: XCUIApplication) -> XCUIElement {
        app.tabBars.buttons.element(boundBy: 4)
    }

    // ---- Tabs ----

    // ---- Screens ----
    static func navBarHome(_ app: XCUIApplication, performTest: Bool = true) -> XCUIElement {
        let titleId = Strings.tabTitleHome.automatedId()
        let homeScreen = app.navigationBars[titleId]
        _ = homeScreen.waitForExistence(timeout: 1)

        if performTest {
            XCTAssertTrue(
                homeScreen.exists,
                "\(titleId) navigation bar not found")
        }

        return homeScreen
    }

    static func navBarHistory(_ app: XCUIApplication, performTest: Bool = true) -> XCUIElement {
        let titleId = Strings.tabTitleHistory.automatedId()
        let historyScreen = app.navigationBars[titleId]
        _ = historyScreen.waitForExistence(timeout: 1)

        if performTest {
            XCTAssertTrue(
                historyScreen.exists,
                "\(titleId) navigation bar not found")
        }

        return historyScreen
    }

    static func navBarInProgress(_ app: XCUIApplication, performTest: Bool = true) -> XCUIElement {
        let titleId = Strings.tabTitleInProgress.automatedId()
        let inProgressScreen = app.navigationBars[titleId]
        _ = inProgressScreen.waitForExistence(timeout: 1)

        if performTest {
            XCTAssertTrue(
                inProgressScreen.exists,
                "\(titleId) navigation bar not found")
        }

        return inProgressScreen
    }

    static func navBarMedications(_ app: XCUIApplication, performTest: Bool = true) -> XCUIElement {
        let titleId = Strings.tabTitleMedications.automatedId()
        let medicationScreen = app.navigationBars[titleId]
        _ = medicationScreen.waitForExistence(timeout: 1)

        if performTest {
            XCTAssertTrue(
                medicationScreen.exists,
                "\(titleId) navigation bar not found")
        }

        return medicationScreen
    }

    static func navBarSettings(_ app: XCUIApplication, performTest: Bool = true) -> XCUIElement {
        let titleId = Strings.tabTitleSettings.automatedId()
        let settingsScreen = app.navigationBars[titleId]
        _ = settingsScreen.waitForExistence(timeout: 1)

        if performTest {
            XCTAssertTrue(
                settingsScreen.exists,
                "\(titleId) navigation bar not found")
        }

        return settingsScreen
    }

    static func navBarAddDose(_ app: XCUIApplication) -> XCUIElement {
        let titleId = Strings.doseEditAddDose.automatedId()
        let addDoseScreen = app.navigationBars[titleId]
        _ = addDoseScreen.waitForExistence(timeout: 1)

        XCTAssertTrue(
            addDoseScreen.exists,
            "\(titleId) navigation bar not found")

        return addDoseScreen
    }

    static func navBarAddMed(_ app: XCUIApplication) -> XCUIElement {
        let titleId = Strings.medEditAddMed.automatedId()
        let addMedScreen = app.navigationBars[titleId]
        _ = addMedScreen.waitForExistence(timeout: 1)

        XCTAssertTrue(
            addMedScreen.exists,
            "\(titleId) navigation bar not found")

        return addMedScreen
    }

    // ---- Screens ----
}

extension XCUIElement {
    func clearText() {
        guard let stringValue = value as? String else {
            return
        }
        // workaround for apple bug
        if let placeholderString = placeholderValue, placeholderString == stringValue {
            return
        }

        var deleteString = String()
        for _ in stringValue {
            deleteString += XCUIKeyboardKey.delete.rawValue
        }
        typeText(deleteString)
    }
}
