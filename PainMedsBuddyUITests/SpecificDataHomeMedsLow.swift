//
//  SpecificDataHomeMedsLow.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import SwiftyJSON
import XCTest

class SpecificDataHomeMedsLow: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        do {
            var json: JSON = try DataFile.readBundleJson(fileSuffix: "5dose-5med")

            // --- Setup ---
            json["doses"].arrayObject?.removeLast(5)

            json["meds"][0]["title"].stringValue = "Water"
            json["meds"][0]["hidden"].boolValue = false
            json["meds"][0]["remaining"].int16Value = 2
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

    func testHomeLowEditMedBackHasTabBar() {
        BasicAction.tapTabHome(app)

        app.swipeUp()

        let row = app.buttons[
            Strings.homeAccessibilityIconRemainingEdit.automatedId()
        ]

        _ = row.waitForExistence(timeout: 2)

        row.forceTap()

        let navBar = Elements.navBarEditMed(app)
        _ = navBar.waitForExistence(timeout: 2)

        navBar.buttons[Strings.commonCancel.automatedId()].tap()

        // INFO: Confirm on home screen
        _ = Elements.navBarHome(app)

        XCTAssertEqual(
            Elements.tabSideButtonCount(app),
            5,
            "There should be 5 tabs in the app."
        )
    }

    func testHomeLowEditMed() {
        BasicAction.tapTabHome(app)

        app.swipeUp()

        let row = app.buttons[
            Strings.homeAccessibilityIconRemainingEdit.automatedId()
        ]

        _ = row.waitForExistence(timeout: 2)

        row.forceTap()

        // INFO: Confirm on med edit screen
        _ = Elements.navBarEditMed(app)

        app.textFields[Strings.medEditTitleText.automatedId()].tap()

        // When
        app.keys["space"].tap()

        if UIDevice.current.userInterfaceIdiom != .pad {
            app.keys["more"].tap()
        } else {
            app.keys["numbers"].firstMatch.press(forDuration: 0.1)
        }

        app.keys["2"].tap()
        app.buttons["Return"].tap()

        let navBar = Elements.navBarEditMed(app)
        navBar.buttons[Strings.commonSave.automatedId()].tap()

        // INFO: Confirm on home screen
        _ = Elements.navBarHome(app)

        // Then
        let predicate = NSPredicate(format: "label CONTAINS 'Water 2'")
        let element = app.buttons.element(matching: predicate)

        // NOTE: Not available in iOS 14
        if #available(iOS 15, *) {
            XCTAssertTrue(element.exists, "The edited medication should be visible in the list.")
        }
    }
}
