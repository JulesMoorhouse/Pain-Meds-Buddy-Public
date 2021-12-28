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
        try dataController.createSampleData()

        XCTAssertEqual(
            dataController.count(for: Med.fetchRequest()),
            DataController.totalSampleMeds,
            "There should be \(DataController.totalSampleMeds) sample meds.")

        XCTAssertEqual(
            dataController.count(for: Dose.fetchRequest()),
            DataController.totalSampleDoses,
            "There should be \(DataController.totalSampleDoses) sample doses.")
    }

    func testDeleteAllClearsEverything() throws {
        try dataController.createSampleData()
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
