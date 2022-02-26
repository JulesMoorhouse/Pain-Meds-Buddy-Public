//
//  SpecificDataMedListSort.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import SwiftyJSON
import XCTest

class SpecificDataMedListSort: XCTestCase {
    var app: XCUIApplication!

    let buttons: [String] = ["Med Apple", "Med Banana", "Med Clementine", "Med Fig", "Med Grape"]
    override func setUpWithError() throws {
        continueAfterFailure = false

        do {
            var json: JSON = try DataFile.readBundleJson(fileSuffix: "5dose-5med")

            // --- Setup ---
            json["meds"][0]["title"].stringValue = buttons[1]
            json["meds"][1]["title"].stringValue = buttons[0]
            json["meds"][2]["title"].stringValue = buttons[2]
            json["meds"][3]["title"].stringValue = buttons[4]
            json["meds"][4]["title"].stringValue = buttons[3]
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

    func testMedSortByTitle() {
        // Given
        BasicAction.tapTabMedications(app)

        let sortButton = app.buttons[Strings.commonSort.automatedId()]

        XCTAssertTrue(
            sortButton.exists,
            "Settings acknowledgements button not found"
        )

        sortButton.tap()

        let actionSheet = app.sheets.firstMatch
        _ = actionSheet.waitForExistence(timeout: 2)

        actionSheet.buttons.element(boundBy: 2).tap()

        // INFO: Confirm on medications screen
        _ = Elements.navBarMedications(app)

        let predicate = NSPredicate(format: "label CONTAINS 'Med '")
        let elements = app.buttons.matching(predicate)

        for index in 0 ... 4 {
            let button = elements.element(boundBy: index)

            let condition = button.label.contains(buttons[index])

            XCTAssertTrue(
                condition,
                "Sort order incorrect!"
            )
        }
    }
}
