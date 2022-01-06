//
//  DevelopmentTests.swift
//  PainMedsBuddyTests
//
//  Created by Jules Moorhouse.
//

import CoreData
@testable import PainMedsBuddy
import XCTest

class DevelopmentTests: BaseTestCase {
    func testSampleDataCreationWorks() throws {
        try dataController.createSampleData(
            medsRequired: 20,
            medDosesRequired: 20)

        XCTAssertEqual(
            dataController.count(for: Med.fetchRequest()),
            20,
            "There should be \(20) sample meds.")

        XCTAssertEqual(
            dataController.count(for: Dose.fetchRequest()),
            20*20,
            "There should be \(20*20) sample doses.")
    }

    func testDeleteAllClearsEverything() throws {
        try dataController.createSampleData(
            medsRequired: 20,
            medDosesRequired: 20)
        dataController.deleteAll()

        XCTAssertEqual(
            dataController.count(for: Med.fetchRequest()),
            0,
            "deleteAll() should leave 0 meds")

        XCTAssertEqual(
            dataController.count(for: Dose.fetchRequest()),
            0,
            "deleteAll() should leave 0 doses")
    }

    func testExampleDoseIsElapsed() {
        let dose = Dose.example
        XCTAssertTrue(dose.elapsed, "The example dose should be elapsed.")
    }

    func testExampleMedIsAmountDefaultOne() {
        let med = Med.example
        XCTAssertEqual(med.defaultAmount, 1, "The example med should be defaultAmount = 1.")
    }
}
