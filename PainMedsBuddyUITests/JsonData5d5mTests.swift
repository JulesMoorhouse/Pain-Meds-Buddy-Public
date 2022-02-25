//
//  JsonData5d5mTests.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import SwiftyJSON
import XCTest

class JsonData5d5mTests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        do {
            var json: JSON = try DataFile.readBundleJson(fileSuffix: "5dose-5med")

            // --- Setup ---
            let newDouble: TimeInterval = Date().timeIntervalSinceReferenceDate

            json["doses"][0]["takeDate"].doubleValue = Double(newDouble)
            json["doses"][0]["elapsed"].boolValue = false
            json["doses"].arrayObject?.removeLast(3)

            json["meds"][0]["title"].stringValue = "Water"
            json["meds"][0]["remaining"].int16Value = 123
            json["meds"].arrayObject?.removeLast(3)
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

    func testJsonDataFile() {
        BasicAction.tapTabMedications(app)

        app.swipeUp()
    }
}
