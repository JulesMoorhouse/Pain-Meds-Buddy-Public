//
//  JsonDataTexts.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import SwiftyJSON
import XCTest

class JsonDataTests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        do {
            var json: JSON = try DataFile.readBundleJson()

            // --- Setup ---
            let newDouble: TimeInterval = Date().timeIntervalSinceReferenceDate

            json["doses"][0]["takeDate"].doubleValue = Double(newDouble)
            json["doses"][0]["elapsed"].boolValue = false
            json["meds"][0]["title"].stringValue = "Water"
            json["meds"][0]["remaining"].int16Value = 123
            // --- Setup ---

            let string: String = "\(json)"

            if let url = DataFile.writeToUrl(jsonString: string) {
                app = XCUIApplication()

                app.launchArguments = ["enable-ui-testing", "[0,0]"]
                app.launchArguments.append("-fileUrlPath")
                // app.launchArguments.append(sampleTextFileURL().path)
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

extension String: Error {}
