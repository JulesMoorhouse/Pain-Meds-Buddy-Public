//
//  SpecificDataHomeCurrentElapsed.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import SwiftyJSON
import XCTest

class SpecificDataHomeCurrentElapsed: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        do {
            var json: JSON = try DataFile.readBundleJson(fileSuffix: "5dose-5med")

            // --- Setup ---
            json["doses"][0]["takeDate"].stringValue = Date().dataFileFormat
            json["doses"][0]["elapsed"].boolValue = true
            json["doses"].arrayObject?.removeLast(4)

            json["meds"][0]["title"].stringValue = "Water"
            json["meds"][0]["hidden"].boolValue = false
            json["meds"][0]["remaining"].int16Value = 123
            json["meds"][0]["lastTakeDate"].stringValue = Date().dataFileFormat
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

    func testHomeProgressCurrentNoElapsed() {
        BasicAction.tapTabHome(app)

        _ = Elements.navBarHome(app, performTest: false)

        let row = app.buttons[
            Strings.doseProgressAccessibilityRemaining.automatedId()
        ]

        // Then
        XCTAssertFalse(
            row.exists,
            "Home current meds are showing"
        )
    }
}
