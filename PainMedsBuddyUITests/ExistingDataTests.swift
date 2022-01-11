//
//  PainMedsBuddyUITests.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import XCTest

class ExistingDataTests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["enable-ui-testing"]
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
        app.buttons[Strings.homeAccessibilityIconTaken.automatedId()].firstMatch.tap()

        let textField = app.textFields[Strings.doseEditAmount.automatedId()]
        textField.doubleTap()
        textField.clearText()

        // When
        app.keys["2"].tap()
        app.keys["9"].tap()

        BasicAction.tapBackButton(app)

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

        let section = app.otherElements[Strings.homeMedsRunningOut.automatedId()]

        XCTAssertTrue(
            section.exists,
            "Home low meds section not showing"
        )
    }

    func testHomeHasRecentMeds() {
        BasicAction.tapTabHome(app)

        let section = app.otherElements[Strings.homeRecentlyTaken.automatedId()]

        XCTAssertTrue(
            section.exists,
            "Home recent meds section not showing"
        )
    }

    func TODO_testSortOrder() {
        // To Do
        // test sort order popup shows and changes sort order of items
        // do on med select and meds view
    }

    func TODO_testMedSelection() {
        // To Do
    }

    func TODO_testHomeProgressAvailable() {
        // To Do
        // test that the home progress circles, once available
        // disappear after a set period
    }

    func TODO_testHomeLowMedsAreCorrect() {
        // To Do
        // test that only low meds are show at the set low value
    }

    func TODO_testHomeLowMedsShowEditedValues() {
        // To Do
    }

    func TODO_testHomeRecentMedsShowEditedValues() {
        // To Do
    }

    func TODO_testHomeInProgressDosesShowEditedValues() {
        // To Do
    }
}
