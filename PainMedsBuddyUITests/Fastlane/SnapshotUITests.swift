//
//  SnapshotUITests.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import XCTest

class SnapshotUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["enable-snapshot-ui-testing"]
        setupSnapshot(app)
        app.launch()
    }

    func testWalkThrough() {
        BasicAction.tapTabHome(app)
        snapshot("01-Home")

        BasicAction.tapTabMedications(app)
        snapshot("02-Medications")

        BasicAction.tapMedicationTabAddButton(app)

        // NOTE: Expand color / symbol section
        app.swipeUp()
        app.buttons[Strings.medEditAdvancedExpandedAID.automatedId()].tap()
        app.swipeDown()

        snapshot("03-AddMed")

        BasicAction.tapBackButton(app)

        // INFO: Confirm on medications screen
        _ = Elements.navBarMedications(app)

        BasicAction.tapTabHistory(app)
        snapshot("04-History")

        BasicAction.tapHistoryAddButton(app)

        // NOTE: Not required for app store, but used in readme
        snapshot("05-AddDose")
    }
}
