//
//  OneMedTests.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import XCTest

class OneMedTests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["enable-ui-testing", "[1,0]"]
        app.launch()
    }

    func testAddTwoDose() {
        // Given
        // INFO: Add a basic dose
        BasicAction.tapTabInProgress(app)

        for addCount in 1 ... 2 {
            BasicAction.tapInProgressAddButton(app)

            let textField = app.textFields[Strings.doseEditAmount.automatedId()]
            _ = textField.waitForExistence(timeout: 2)

            textField.doubleTap()
            textField.clearText()

            // When
            app.keys["2"].tap()
            app.keys["9"].tap()
            app.keys["\(addCount)"].tap()

            // INFO: Back button tap on add dose screen
            BasicAction.tapAddDoseSaveButton(app)

            // INFO: Confirm on in progress screen
            _ = Elements.navBarInProgress(app, performTest: false)

            // When
            let rowCount = app.buttons.matching(identifier:
                Strings.homeAccessibilityIconTaken.automatedId())
                .count

            // Then
            XCTAssertEqual(
                rowCount,
                addCount,
                "There should be 1 list rows initially."
            )

            let predicate = NSPredicate(format: "label CONTAINS '29\(addCount)'")
            let element = app.buttons.element(matching: predicate)

            XCTAssertTrue(element.exists, "The added dose should be visible in the list.")
        }

    }

    func testEditMed() {
        BasicAction.tapTabMedications(app)

        // Given
        // INFO: Tap newly added item on medications list
        app.buttons[Strings.homeAccessibilityIconRemaining.automatedId()].tap()

        // INFO: Confirm on med edit screen
        _ = Elements.navBarEditMed(app)

        app.textFields[Strings.medEditTitleText.automatedId()].tap()

        // When
        app.keys["space"].tap()

        if UIDevice.current.userInterfaceIdiom != .pad {
            app.keys["more"].tap()
        } else {
            app.keys["numbers"].firstMatch.press(forDuration: 0.1)
        }

        app.keys["2"].tap()
        app.buttons["Return"].tap()

        BasicAction.tapEditMedSaveButton(app)

        // Then
        let predicate = NSPredicate(format: "label CONTAINS ' 2'")
        let element = app.buttons.element(matching: predicate)

        XCTAssertTrue(element.exists, "The edited medication should be visible in the list.")
    }
}
