//
//  Elements.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import XCTest

class Elements: XCTestCase {
    // INFO: These helper methods should not have any
    // parameters and should perform simple actions
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
        let titleId = Strings.commonAppName.automatedId()
        let homeScreen = app.navigationBars[titleId]
        _ = homeScreen.waitForExistence(timeout: 2)

        if performTest {
            XCTAssertTrue(
                homeScreen.exists,
                "\(titleId) navigation bar not found"
            )
        }

        return homeScreen
    }

    static func navBarHistory(_ app: XCUIApplication, performTest: Bool = true) -> XCUIElement {
        let titleId = Strings.tabTitleHistory.automatedId()
        let historyScreen = app.navigationBars[titleId]
        _ = historyScreen.waitForExistence(timeout: 2)

        if performTest {
            XCTAssertTrue(
                historyScreen.exists,
                "\(titleId) navigation bar not found"
            )
        }

        return historyScreen
    }

    static func navBarInProgress(_ app: XCUIApplication, performTest: Bool = true) -> XCUIElement {
        let titleId = Strings.tabTitleInProgress.automatedId()
        let inProgressScreen = app.navigationBars[titleId]
        _ = inProgressScreen.waitForExistence(timeout: 2)

        if performTest {
            XCTAssertTrue(
                inProgressScreen.exists,
                "\(titleId) navigation bar not found"
            )
        }

        return inProgressScreen
    }

    static func navBarMedications(_ app: XCUIApplication, performTest: Bool = true) -> XCUIElement {
        let titleId = Strings.tabTitleMedications.automatedId()
        let medicationScreen = app.navigationBars[titleId]
        _ = medicationScreen.waitForExistence(timeout: 2)

        if performTest {
            XCTAssertTrue(
                medicationScreen.exists,
                "\(titleId) navigation bar not found"
            )
        }

        return medicationScreen
    }

    static func navBarSettings(_ app: XCUIApplication, performTest: Bool = true) -> XCUIElement {
        let titleId = Strings.tabTitleSettings.automatedId()
        let settingsScreen = app.navigationBars[titleId]
        _ = settingsScreen.waitForExistence(timeout: 2)

        if performTest {
            XCTAssertTrue(
                settingsScreen.exists,
                "\(titleId) navigation bar not found"
            )
        }

        return settingsScreen
    }

    static func navBarSettingsDeveloper(_ app: XCUIApplication, performTest: Bool = true) -> XCUIElement {
        let titleId = Strings.settingsDeveloper.automatedId()
        let settingsScreen = app.navigationBars[titleId]
        _ = settingsScreen.waitForExistence(timeout: 2)

        if performTest {
            XCTAssertTrue(
                settingsScreen.exists,
                "\(titleId) navigation bar not found"
            )
        }

        return settingsScreen
    }

    static func navBarSettingsAdvanced(_ app: XCUIApplication, performTest: Bool = true) -> XCUIElement {
        let titleId = Strings.settingsAdvanced.automatedId()
        let settingsScreen = app.navigationBars[titleId]
        _ = settingsScreen.waitForExistence(timeout: 2)

        if performTest {
            XCTAssertTrue(
                settingsScreen.exists,
                "\(titleId) navigation bar not found"
            )
        }

        return settingsScreen
    }

    static func navBarSettingsAcknowledgements(_ app: XCUIApplication, performTest: Bool = true) -> XCUIElement {
        let titleId = Strings.settingsAcknowledgements.automatedId()
        let settingsScreen = app.navigationBars[titleId]
        _ = settingsScreen.waitForExistence(timeout: 2)

        if performTest {
            XCTAssertTrue(
                settingsScreen.exists,
                "\(titleId) navigation bar not found"
            )
        }

        return settingsScreen
    }

    static func navBarAddDose(_ app: XCUIApplication) -> XCUIElement {
        let titleId = Strings.doseEditAddDose.automatedId()
        let addDoseScreen = app.navigationBars[titleId]
        _ = addDoseScreen.waitForExistence(timeout: 2)

        XCTAssertTrue(
            addDoseScreen.exists,
            "\(titleId) navigation bar not found"
        )

        return addDoseScreen
    }

    static func navBarEditDose(_ app: XCUIApplication) -> XCUIElement {
        let titleId = Strings.doseEditEditDose.automatedId()
        let editDoseScreen = app.navigationBars[titleId]
        _ = editDoseScreen.waitForExistence(timeout: 2)

        XCTAssertTrue(
            editDoseScreen.exists,
            "\(titleId) navigation bar not found"
        )

        return editDoseScreen
    }

    static func navBarAddMed(_ app: XCUIApplication) -> XCUIElement {
        let titleId = Strings.medEditAddMed.automatedId()
        let addMedScreen = app.navigationBars[titleId]
        _ = addMedScreen.waitForExistence(timeout: 2)

        XCTAssertTrue(
            addMedScreen.exists,
            "\(titleId) navigation bar not found"
        )

        return addMedScreen
    }

    static func navBarEditMed(_ app: XCUIApplication) -> XCUIElement {
        let titleId = Strings.medEditEditMed.automatedId()
        let editMedScreen = app.navigationBars[titleId]
        _ = editMedScreen.waitForExistence(timeout: 2)

        XCTAssertTrue(
            editMedScreen.exists,
            "\(titleId) navigation bar not found"
        )

        return editMedScreen
    }

    static func navBarMedSelect(_ app: XCUIApplication) -> XCUIElement {
        let titleId = Strings.selectMedSelectMed.automatedId()
        let selectMedScreen = app.navigationBars[titleId]
        _ = selectMedScreen.waitForExistence(timeout: 2)

        XCTAssertTrue(
            selectMedScreen.exists,
            "\(titleId) navigation bar not found"
        )

        return selectMedScreen
    }
    // ---- Screens ----
}

extension XCUIElement {
    func clearText() {
        guard let stringValue = value as? String else {
            return
        }

        // INFO: Workaround for apple bug
        if let placeholderString = placeholderValue, placeholderString == stringValue {
            return
        }

        var deleteString = String()
        for _ in stringValue {
            deleteString += XCUIKeyboardKey.delete.rawValue
        }
        typeText(deleteString)
    }

    func selectPicker(value: String, timeout: TimeInterval) {
        let pickerWheel = pickerWheels.firstMatch
        let row = pickerWheels[value]

        while !row.waitForExistence(timeout: timeout) {
            pickerWheel.adjust(toPickerWheelValue: value)
        }
    }

    public func swipeUp(to element: XCUIElement) {
        while !elementIsWithinWindow(element: element) {
            XCUIApplication().gentleSwipe(.up)
        }
    }

    private func elementIsWithinWindow(element: XCUIElement) -> Bool {
        guard element.exists, element.isHittable else { return false }
        return true
    }

    enum Direction: Int {
        // swiftlint:disable:next identifier_name
        case up, down, left, right
    }

    func gentleSwipe(_ direction: Direction) {
        let half: CGFloat = 0.5
        let adjustment: CGFloat = 0.05 // 0.25
        let pressDuration: TimeInterval = 0.05

        let lessThanHalf = half - adjustment
        let moreThanHalf = half + adjustment

        let centre = coordinate(withNormalizedOffset: CGVector(dx: half, dy: half))
        let aboveCentre = coordinate(withNormalizedOffset: CGVector(dx: half, dy: lessThanHalf))
        let belowCentre = coordinate(withNormalizedOffset: CGVector(dx: half, dy: moreThanHalf))
        let leftOfCentre = coordinate(withNormalizedOffset: CGVector(dx: lessThanHalf, dy: half))
        let rightOfCentre = coordinate(withNormalizedOffset: CGVector(dx: moreThanHalf, dy: half))

        switch direction {
        case .up:
            centre.press(forDuration: pressDuration, thenDragTo: aboveCentre)
        case .down:
            centre.press(forDuration: pressDuration, thenDragTo: belowCentre)
        case .left:
            centre.press(forDuration: pressDuration, thenDragTo: leftOfCentre)
        case .right:
            centre.press(forDuration: pressDuration, thenDragTo: rightOfCentre)
        }
    }
}
