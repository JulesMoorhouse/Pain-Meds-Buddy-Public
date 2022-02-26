//
//  SpecificDataHomeAvailable.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import SwiftyJSON
import XCTest

class SpecificDataHomeAvailable: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        do {
            var json: JSON = try DataFile.readBundleJson(fileSuffix: "5dose-5med")

            // --- Setup ---
            let threeHoursAgo: Date = Calendar.current.date(byAdding: .hour, value: -3, to: Date())!
            let threeHoursAgoDouble: TimeInterval = threeHoursAgo.timeIntervalSinceReferenceDate

            let sevenHoursAhead: Date = Calendar.current.date(byAdding: .hour, value: 7, to: Date())!
            let sevenHoursAheadDouble: TimeInterval = sevenHoursAhead.timeIntervalSinceReferenceDate

            json["doses"][0]["takeDate"].doubleValue = Double(threeHoursAgoDouble)
            json["doses"][0]["softElapsedDate"].doubleValue = Double(sevenHoursAheadDouble)
            json["doses"][0]["elapsed"].boolValue = true
            json["doses"].arrayObject?.removeLast(4)

            json["meds"][0]["title"].stringValue = "Water"
            json["meds"][0]["hidden"].boolValue = false
            json["meds"][0]["lastTakeDate"].doubleValue = Double(threeHoursAgoDouble)

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

    func testHomeProgressAvailableAddDose() {
        BasicAction.tapTabHome(app)

        // INFO: Confirm on home screen
        _ = Elements.navBarHome(app)

        let row = app.buttons[
            Strings.doseProgressAccessibilityRemaining.automatedId()
        ]

        _ = row.waitForExistence(timeout: 2)

        row.forceTap()

        let navBar = Elements.navBarAddDose(app)
        navBar.buttons[Strings.commonSave.automatedId()].tap()

        // INFO: Confirm on home screen
        _ = Elements.navBarHome(app)

        let rowCount = app.buttons.matching(identifier:
            Strings.doseProgressAccessibilityRemaining.automatedId())
            .count

        // Then
        XCTAssertEqual(
            rowCount,
            1,
            "There should be no rows."
        )
    }
}
