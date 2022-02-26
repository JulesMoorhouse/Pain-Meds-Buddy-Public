//
//  BasicDataTests.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import XCTest

class BasicDataTests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["enable-ui-testing", "[5,5]"]
        app.launch()
    }

    func testMedsHasSort() {
        BasicAction.tapTabMedications(app)

        let sortButton = app.buttons[Strings.commonSort.automatedId()]

        XCTAssertTrue(
            sortButton.exists,
            "Medications sort button not found"
        )
    }

    func testEditDose() {
        // Given
        BasicAction.tapTabInProgress(app)

        let row = app.buttons[
            Strings.homeAccessibilityIconTaken.automatedId()
        ].firstMatch
        _ = row.waitForExistence(timeout: 2)
        row.tap()

        let textField = app.textFields[Strings.doseEditAmount.automatedId()]
        _ = textField.waitForExistence(timeout: 2)

        textField.doubleTap()
        textField.clearText()

        // When
        app.keys["2"].tap()
        app.keys["9"].tap()

        BasicAction.tapEditDoseSaveButton(app)

        // Then
        let predicate = NSPredicate(format: "label CONTAINS '29'")
        let element = app.buttons.element(matching: predicate)

        XCTAssertTrue(element.exists, "The edited dose should be visible in the list.")
    }

    func testHomeHasProgress() {
        BasicAction.tapTabHome(app)

        let section = app.otherElements[Strings.homeCurrentMeds.automatedId()]

        XCTAssertTrue(
            section.exists,
            "Home current meds section not showing"
        )
    }

    func testHomeHasLowMeds() {
        BasicAction.tapTabHome(app)

        app.swipeUp()

        let row = app.buttons[
            Strings.homeAccessibilityIconRemainingEdit.automatedId()
        ].firstMatch

        XCTAssertTrue(
            row.exists,
            "Home low meds row not showing"
        )
    }
}
