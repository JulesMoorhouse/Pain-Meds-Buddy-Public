//
//  SpecificDataSelectMed.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import SwiftyJSON
import XCTest

class SpecificDataSelectMed: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        do {
            var json: JSON = try DataFile.readBundleJson(fileSuffix: "5dose-5med")

            // --- Setup ---
            let oneDayAgo: Date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!

            let oneDayAgoDouble: TimeInterval = oneDayAgo.timeIntervalSinceReferenceDate

            let twoDayAgo: Date = Calendar.current.date(byAdding: .day, value: -2, to: Date())!

            let twoDayAgoDouble: TimeInterval = twoDayAgo.timeIntervalSinceReferenceDate

            // So have 2 meds, first med selection is determined by lastTakenDate
            json["meds"][0]["title"].stringValue = "Bronze"
            json["meds"][0]["lastTakeDate"].doubleValue = Double(oneDayAgoDouble)

            json["meds"][1]["title"].stringValue = "Silver"
            json["meds"][1]["lastTakeDate"].doubleValue = Double(twoDayAgoDouble)

            json["meds"].arrayObject?.removeLast(2)
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

    func testCanSelectMed() {
        BasicAction.tapTabInProgress(app)

        BasicAction.tapInProgressAddButton(app)

        let row = app.buttons[
            Strings.doseEditMedication.automatedId()
        ]

        _ = row.waitForExistence(timeout: 2)

        row.forceTap()

        _ = Elements.navBarMedSelect(app).waitForExistence(timeout: 2)

        let predicate = NSPredicate(format: "label CONTAINS 'Silver'")
        let button = app.buttons.element(matching: predicate)

        button.tap()

        _ = Elements.navBarAddDose(app)

        let predicate2 = NSPredicate(format: "label CONTAINS 'Silver'")
        let button2 = app.buttons.element(matching: predicate2)

        XCTAssertTrue(button2.exists, "The med selection not found.")
    }
}
