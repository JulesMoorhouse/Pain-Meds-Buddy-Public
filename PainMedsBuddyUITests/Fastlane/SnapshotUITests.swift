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
        BasicAction.tapTabHome(app)
        snapshot("01-Home")
                
        BasicAction.tapTabMedications(app)
        snapshot("02-Medications")
                
        BasicAction.tapMedicationTabAddButton(app)
        snapshot("03-AddMed")
        
        BasicAction.tapBackButton(app)
        
        BasicAction.tapTabInProgress(app)
        snapshot("04-History")
        
        BasicAction.tapInProgressAddButton(app)
        snapshot("05-AddDose")

    }
}
