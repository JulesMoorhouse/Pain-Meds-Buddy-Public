//
//  SpecificDataHomeRecentHiddenMed.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import SwiftyJSON
import XCTest

class SpecificDataHomeRecentHiddenMed: XCTestCase {
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
            json["meds"][0]["hidden"].boolValue = true
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

    func testHomeHasNoRecentHiddenMeds() {
        BasicAction.tapTabHome(app)

        _ = Elements.navBarHome(app, performTest: false)

        let labelId = Strings.commonEmptyView.automatedId()
        let someView = app.staticTexts[labelId]

        // Then
        XCTAssertTrue(
            someView.exists,
            "Home empty placeholder label not showing"
        )
    }
}
