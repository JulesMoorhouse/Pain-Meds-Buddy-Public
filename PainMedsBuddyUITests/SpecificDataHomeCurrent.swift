//
//  SpecificDataHomeCurrent.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import SwiftyJSON
import XCTest

class SpecificDataHomeCurrent: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        do {
            var json: JSON = try DataFile.readBundleJson(fileSuffix: "5dose-5med")

            // --- Setup ---
            let nowDouble: TimeInterval = Date().timeIntervalSinceReferenceDate

            json["doses"][0]["takeDate"].doubleValue = Double(nowDouble)
            json["doses"][0]["elapsed"].boolValue = false
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

    func testHomeProgressAddDoseBackHasTabBar() {
        BasicAction.tapTabHome(app)

        let nextButton = app.buttons[Strings.doseProgressAccessibilityRemaining.automatedId()]

        nextButton.forceTap()

        // INFO: Confirm on add dose screen
        _ = Elements.navBarEditDose(app)

        let navBar = Elements.navBarEditDose(app)
        navBar.buttons[Strings.commonCancel.automatedId()].tap()

        // INFO: Confirm on home screen
        _ = Elements.navBarHome(app)

        XCTAssertEqual(
            Elements.tabSideButtonCount(app),
            5,
            "There should be 5 tabs in the app."
        )
    }

    func testHomeProgressEditDose() {
        BasicAction.tapTabHome(app)

        let nextButton = app.buttons[Strings.doseProgressAccessibilityRemaining.automatedId()]

        nextButton.forceTap()

        // INFO: Confirm on add dose screen
        _ = Elements.navBarEditDose(app)

        // --
        let textField = app.textFields[Strings.doseEditAmount.automatedId()]
        _ = textField.waitForExistence(timeout: 2)

        textField.doubleTap()
        textField.clearText()

        // When
        app.keys["2"].tap()
        app.keys["9"].tap()
        // --

        let navBar = Elements.navBarEditDose(app)
        navBar.buttons[Strings.commonSave.automatedId()].tap()

        // INFO: Confirm on home screen
        _ = Elements.navBarHome(app)
    }
}
