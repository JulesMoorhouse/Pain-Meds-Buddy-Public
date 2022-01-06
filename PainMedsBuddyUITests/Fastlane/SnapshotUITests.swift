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
        app.launchArguments = ["enable-ui-testing"]
        setupSnapshot(app)
        app.launch()
    }

    func testWalkThrough() {
        BasicAction.tapTabMedications(app)
        snapshot("Medications")
    }
}
