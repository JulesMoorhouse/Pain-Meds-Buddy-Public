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

    func testAddDose() {
        // Given
        // Add a basic dose
        BasicAction.tapTabInProgress(app)
        BasicAction.tapInProgressAddButton(app)

        // Back button tap on add dose screen
        BasicAction.tapAddDoseSaveButton(app)

        // Confirm on in progress screen
        _ = Elements.navBarInProgress(app, performTest: false)

        // When
        let rowCount = app.tables.cells.count

        // Then
        XCTAssertEqual(
            rowCount,
            1,
            "There should be 1 list rows initially."
        )
    }

    func testEditMed() {
        BasicAction.tapTabMedications(app)

        // Given
        // tap newly added item on medications list
        app.buttons[Strings.homeAccessibilityIconRemaining.automatedId()].tap()

        app.textFields[Strings.medEditTitleText.automatedId()].tap()

        // When
        app.keys["space"].tap()

        if UIDevice.current.userInterfaceIdiom != .pad {
            app.keys["more"].tap()
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
