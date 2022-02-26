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
            let nowDouble: TimeInterval = Date().timeIntervalSinceReferenceDate

            json["doses"][0]["takeDate"].doubleValue = Double(nowDouble)
            json["doses"][0]["elapsed"].boolValue = true
            json["doses"].arrayObject?.removeLast(4)

            json["meds"][0]["title"].stringValue = "Water"
            json["meds"][0]["hidden"].boolValue = false
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

        let labelId = Strings.commonEmptyView.automatedId()
        let someView = app.staticTexts[labelId]

        // Then
        XCTAssertTrue(
            someView.exists,
            "Home empty placeholder label not showing"
        )
    }
}
