//
//  JsonData1d1mTests.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import SwiftyJSON
import XCTest

class JsonData1d1mTests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        do {
            var json: JSON = try DataFile.readBundleJson(fileSuffix: "5dose-5med")

            // --- Setup ---
            let newDouble: TimeInterval = Date().timeIntervalSinceReferenceDate

            json["doses"][0]["takeDate"].doubleValue = Double(newDouble)
            json["doses"][0]["elapsed"].boolValue = false
            json["doses"].arrayObject?.removeLast(4)

            json["meds"][0]["title"].stringValue = "Water"
            json["meds"][0]["remaining"].int16Value = 123
            json["meds"].arrayObject?.removeLast(4)
            // --- Setup ---

            let string: String = "\(json)"

            if let url = DataFile.writeToUrl(jsonString: string) {
                app = XCUIApplication()

                app.launchArguments = ["enable-ui-testing", "[0,0]"]
                app.launchArguments.append("-fileUrlPath")
                app.launchArguments.append(url.path)
                app.launchArguments.append("-fileName")
                app.launchArguments.append("data.json")
                app.launch()
            }

        } catch {
            print("\(error.localizedDescription)")
        }
    }

    func testDoseListDeleteSingle() {
        // Given
        BasicAction.tapTabInProgress(app)

        let row = app.buttons[
            Strings.homeAccessibilityIconTaken.automatedId()
        ].firstMatch
        _ = row.waitForExistence(timeout: 2)

        // When
        row.swipeLeft(velocity: .slow)
        app.buttons["Delete"].tap()

        let rowCount = app.buttons.matching(identifier:
            Strings.homeAccessibilityIconTaken.automatedId())
            .count

        // Then
        XCTAssertEqual(
            rowCount,
            0,
            "There should be no rows."
        )
    }

    func testDoseEditDeleteSingle() {
        // Given
        BasicAction.tapTabInProgress(app)

        let row = app.buttons[
            Strings.homeAccessibilityIconTaken.automatedId()
        ].firstMatch
        _ = row.waitForExistence(timeout: 2)
        row.tap()

        let deleteButton = app.buttons[Strings.doseEditDeleteThisDose.automatedId()]
        _ = deleteButton.waitForExistence(timeout: 2)
        deleteButton.tap()

        // When
        let alert = app.alerts.firstMatch
        _ = alert.waitForExistence(timeout: 2)

        alert.buttons.element(boundBy: 1).tap()

        let labelId = Strings.commonEmptyView.automatedId()
        let someView = app.staticTexts[labelId]
        _ = someView.waitForExistence(timeout: 2)

        // Then
        XCTAssertTrue(
            someView.exists,
            "In Progress empty placeholder label not showing"
        )
    }

    func testMedListDeleteSingle() {
        // Given
        BasicAction.tapTabMedications(app)

        let row = app.buttons.matching(identifier:
                                        Strings.homeAccessibilityIconRemaining.automatedId())

        XCTAssertEqual(
            row.count,
            1,
            "There should be 1 list rows initially."
        )

        // When
        row.firstMatch.swipeLeft(velocity: .slow)
        app.buttons["Delete"].tap()

        let rowCountZero = app.buttons.matching(identifier:
            Strings.homeAccessibilityIconRemaining.automatedId())
            .count

        // Then
        XCTAssertEqual(
            rowCountZero,
            0,
            "There should be no rows."
        )
    }

    func testMedEditDeleteSingle() {
        // Given
        BasicAction.tapTabMedications(app)

        let row = app.buttons[
            Strings.homeAccessibilityIconRemaining.automatedId()
        ].firstMatch
        _ = row.waitForExistence(timeout: 2)
        row.tap()

        let deleteButton = app.buttons[Strings.medEditDeleteThisMed.automatedId()]
        _ = deleteButton.waitForExistence(timeout: 2)
        deleteButton.tap()

        // When
        let alert = app.alerts.firstMatch
        _ = alert.waitForExistence(timeout: 2)

        alert.buttons.element(boundBy: 1).tap()

        let labelId = Strings.commonEmptyView.automatedId()
        let someView = app.staticTexts[labelId]
        _ = someView.waitForExistence(timeout: 2)

        // Then
        XCTAssertTrue(
            someView.exists,
            "In Progress empty placeholder label not showing"
        )
    }

}
