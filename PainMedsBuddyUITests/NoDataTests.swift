//
//  NoDataTests.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import XCTest

class NoDataTests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["wipe-data"]
        app.launch()
    }

    func testAddTwoMedications() {
        // Given
        BasicAction.tapTabMedications(app)

        let labelId = Strings.commonEmptyView.automatedId()
        let someView = app.staticTexts[labelId]

        // Then
        XCTAssertTrue(
            someView.exists,
            "Medications empty placeholder label not showing"
        )

        for addCount in 1 ... 2 {
            // When
            BasicAction.tapMedicationTabAddButton(app)

            // Add details
            // Title
            let title = app.textFields[Strings.medEditTitleText.automatedId()]
            title.doubleTap()
            title.clearText()
            "Paracetamol".forEach { char in
                app.keys["\(char)"].tap()
            }

            // Default Amount
            let defaultAmount = app.textFields[Strings.medEditDefaultAmount.automatedId()]
            defaultAmount.doubleTap()
            defaultAmount.clearText()
            "12".forEach { char in
                app.keys["\(char)"].tap()
            }

            // Dosage
            let dosage = app.textFields[Strings.commonDosage.automatedId()]
            dosage.doubleTap()
            dosage.clearText()

            "100".forEach { char in
                app.keys["\(char)"].tap()
            }

            // Duration
            let hourButton = app.buttons[Strings.medEditDurationPickerHourAID.automatedId()]
            // NOTE: iOS 15 hour button
            if hourButton.exists {
                hourButton.tap()
            } else {
                let duration = app.buttons[Strings.medEditDuration.automatedId()]
                duration.press(forDuration: 0.5)
            }

            let picker = app.pickers[Strings.medEditDurationPickerHourAID.automatedId()]

            _ = picker.waitForExistence(timeout: 2)

            if picker.exists {
                picker.selectPicker(value: "3 hrs", timeout: 1)
            } else {
                // INFO: iOS 15
                let button = app.buttons["3 hrs"]
                if button.exists {
                    button.tap()
                } else {
                    app.swipeUp()
                }
            }

            let okButton = app.buttons[Strings.commonOK.automatedId()]

            // INFO: In iOS 15 dialog isn't used
            if okButton.exists {
                okButton.tap()
            }
            // Measure

            // Form
            let form = app.textFields[Strings.medEditForm.automatedId()]
            app.swipeUp(to: form)

            form.doubleTap()
            form.clearText()
            "Pills".forEach { char in
                app.keys["\(char)"].tap()
            }

            app.buttons["return"].tap()

            // Remaining
            let remaining = app.textFields[Strings.medEditRemaining.automatedId()]
            app.swipeUp(to: remaining)
            remaining.doubleTap()
            remaining.clearText()

            let remainAmount = "\(100 + addCount)"
            remainAmount.forEach { char in
                app.keys["\(char)"].tap()
            }

            // INFO: Save button tap on add med screen
            BasicAction.tapAddMedSaveButton(app)

            // INFO: Confirm on medications screen
            _ = Elements.navBarMedications(app, performTest: false)

            let rowCount = app.buttons.matching(identifier:
                Strings.homeAccessibilityIconRemaining.automatedId())
                .count

            // Then
            XCTAssertEqual(
                rowCount,
                addCount,
                "There should be \(addCount) list rows initially."
            )

            let predicate = NSPredicate(format: "label CONTAINS '\(remainAmount)'")
            let element = app.buttons.element(matching: predicate).firstMatch

            XCTAssertTrue(element.exists, "The added med should be visible in the list.")
        }
    }

    func testEmptyHistory() {
        // Given
        BasicAction.tapTabHistory(app)

        // When - Confirm on history screen
        _ = Elements.navBarHistory(app)

        let labelId = Strings.commonPleaseAdd.automatedId()
        let someView = app.staticTexts[labelId]

        // Then
        XCTAssertTrue(
            someView.exists,
            "History empty placeholder label not showing"
        )
    }

    func testEmptyInProgress() {
        // Given
        BasicAction.tapTabInProgress(app)

        // When - Confirm on in progress screen
        _ = Elements.navBarInProgress(app)

        let labelId = Strings.commonPleaseAdd.automatedId()
        let someView = app.staticTexts[labelId]

        // Then
        XCTAssertTrue(
            someView.exists,
            "In Progress empty placeholder label not showing"
        )
    }

    func testEmptyMeds() {
        // Given
        BasicAction.tapTabMedications(app)

        // When - Confirm on meds screen
        _ = Elements.navBarMedications(app)

        let labelId = Strings.commonEmptyView.automatedId()
        let someView = app.staticTexts[labelId]

        // Then
        XCTAssertTrue(
            someView.exists,
            "Medications empty placeholder label not showing"
        )
    }

    func testEmptyHome() {
        // When - Confirm on home screen
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

    func testMedsHasAdd() {
        // Given
        BasicAction.tapTabMedications(app)

        let labelId = Strings.commonEmptyView.automatedId()
        let someView = app.staticTexts[labelId]

        XCTAssertTrue(
            someView.exists,
            "Medications empty placeholder label not showing"
        )

        // When
        let navBar = Elements.navBarMedications(app)
        let button = navBar.buttons[Strings.medEditAddMed.automatedId()]

        // Then
        XCTAssertTrue(
            button.exists,
            "Medications add button not found"
        )
    }

    func testEnsureMedAddSheetRotateStays() {
        let device = XCUIDevice.shared

        BasicAction.tapTabMedications(app)
        BasicAction.tapMedicationTabAddButton(app)

        _ = Elements.navBarAddMed(app)

        device.orientation = .landscapeLeft

        _ = Elements.navBarAddMed(app)

        device.orientation = .portraitUpsideDown

        _ = Elements.navBarAddMed(app)

        device.orientation = .landscapeRight

        _ = Elements.navBarAddMed(app)

        device.orientation = .portrait

        _ = Elements.navBarAddMed(app)

        let navBar = Elements.navBarAddMed(app)
        navBar.buttons[Strings.commonCancel.automatedId()].tap()

        _ = Elements.navBarMedications(app)
    }

    func testSettingsHasAcknowledgements() {
        // Given
        BasicAction.tapTabSetting(app)

        let ackButton = app.buttons[Strings.settingsAcknowledgements.automatedId()]

        // Then
        XCTAssertTrue(
            ackButton.exists,
            "Settings acknowledgements button not found"
        )
    }

    func testSettingsAdvancedSheetRotateStays() {
        let device = XCUIDevice.shared

        BasicAction.tapTabSetting(app)
        BasicAction.tapSettingsAdvancedButton(app)

        _ = Elements.navBarSettingsAdvanced(app)

        device.orientation = .landscapeLeft

        _ = Elements.navBarSettingsAdvanced(app)

        device.orientation = .portraitUpsideDown

        _ = Elements.navBarSettingsAdvanced(app)

        device.orientation = .landscapeRight

        _ = Elements.navBarSettingsAdvanced(app)

        device.orientation = .portrait

        let navBar = Elements.navBarSettingsAdvanced(app)
        navBar.buttons[Strings.commonClose.automatedId()].tap()

        _ = Elements.navBarSettings(app)
    }

    func testSettingsDeveloperSheetRotateStays() {
        let device = XCUIDevice.shared

        BasicAction.tapTabSetting(app)
        BasicAction.tapSettingsDeveloperButton(app)

        _ = Elements.navBarSettingsDeveloper(app)

        device.orientation = .landscapeLeft

        _ = Elements.navBarSettingsDeveloper(app)

        device.orientation = .portraitUpsideDown

        _ = Elements.navBarSettingsDeveloper(app)

        device.orientation = .landscapeRight

        _ = Elements.navBarSettingsDeveloper(app)

        device.orientation = .portrait

        _ = Elements.navBarSettingsDeveloper(app)

        let navBar = Elements.navBarSettingsDeveloper(app)
        navBar.buttons[Strings.commonClose.automatedId()].tap()

        _ = Elements.navBarSettings(app)
    }

    func testSettingsAcknowledgementsSheetRotateStays() {
        let device = XCUIDevice.shared

        BasicAction.tapTabSetting(app)
        BasicAction.tapSettingsAcknowledgementsButton(app)

        _ = Elements.navBarSettingsAcknowledgements(app)

        device.orientation = .landscapeLeft

        _ = Elements.navBarSettingsAcknowledgements(app)

        device.orientation = .portraitUpsideDown

        _ = Elements.navBarSettingsAcknowledgements(app)

        device.orientation = .landscapeRight

        _ = Elements.navBarSettingsAcknowledgements(app)

        device.orientation = .portrait

        _ = Elements.navBarSettingsAcknowledgements(app)

        let navBar = Elements.navBarSettingsAcknowledgements(app)
        navBar.buttons[Strings.commonClose.automatedId()].tap()

        _ = Elements.navBarSettings(app)
    }
}
