//
//  JsonDataHomeRecent.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import SwiftyJSON
import XCTest

class SpecificDataHomeRecent: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        do {
            var json: JSON = try DataFile.readBundleJson(fileSuffix: "5dose-5med")

            // --- Setup ---
            let threeMinutesAgo: Date = Calendar.current.date(byAdding: .minute, value: -3, to: Date())!
            let oneDayAgo: Date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!

            json["doses"][0]["takeDate"].stringValue = threeMinutesAgo.dataFileFormat
            json["doses"][0]["softDateElapsed"].stringValue = threeMinutesAgo.dataFileFormat
            json["doses"][0]["elapsed"].boolValue = true
            json["doses"].arrayObject?.removeLast(4)

            json["meds"][0]["title"].stringValue = "Water"
            json["meds"][0]["hidden"].boolValue = false
            json["meds"][0]["remaining"].int16Value = 123
            json["meds"][0]["durationSeconds"].int16Value = 14400
            json["meds"][0]["lastTakeDate"].stringValue = oneDayAgo.dataFileFormat
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
                sleep(1)
            }

        } catch {
            print("\(error.localizedDescription)")
        }
    }

    func testHomeHasRecentMeds() {
        BasicAction.tapTabHome(app)

        let row = app.buttons[
            Strings.homeAccessibilityIconTakeNow.automatedId()
        ].firstMatch

        _ = row.waitForExistence(timeout: 2)

        XCTAssertTrue(
            row.exists,
            "Home recent meds section not showing"
        )
    }

    func testHomeRecentTapNextAdd() {
        BasicAction.tapTabHome(app)

        // INFO: Confirm on home screen
        _ = Elements.navBarHome(app)

        let row = app.buttons[
            Strings.homeAccessibilityIconTakeNow.automatedId()
        ].firstMatch

        _ = row.waitForExistence(timeout: 2)

        row.forceTap()

        let navBar = Elements.navBarAddDose(app)
        navBar.buttons[Strings.commonSave.automatedId()].tap()

        // INFO: Confirm on home screen
        _ = Elements.navBarHome(app)

        let rowCount = app.buttons.matching(identifier:
            Strings.homeAccessibilityIconTakeNow.automatedId())
            .count

        // Then
        XCTAssertEqual(
            rowCount,
            0,
            "There should be no rows."
        )
    }

    func testHomeRecentAddDoseBackHasTabBar() {
        BasicAction.tapTabHome(app)

        let row = app.buttons[
            Strings.homeAccessibilityIconTakeNow.automatedId()
        ]

        _ = row.waitForExistence(timeout: 2)

        row.forceTap()

        let navBar = Elements.navBarAddDose(app)
        navBar.buttons[Strings.commonCancel.automatedId()].tap()

        // INFO: Confirm on home screen
        _ = Elements.navBarHome(app)

        XCTAssertEqual(
            Elements.tabSideButtonCount(app),
            5,
            "There should be 5 tabs in the app."
        )
    }
}
