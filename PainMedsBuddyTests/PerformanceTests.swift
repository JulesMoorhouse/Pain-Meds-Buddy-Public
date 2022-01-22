//
//  PerformanceTests.swift
//  PainMedsBuddyTests
//
//  Created by Jules Moorhouse.
//

import CoreData
@testable import PainMedsBuddy
import XCTest

class PerformanceTests: BaseTestCase {
    func testFistMedPerformance() throws {
        // INFO: Create a significant amount of test data
        for _ in 1 ... 100 {
            try dataController.createSampleData(
                appStore: false,
                medsRequested: 20,
                medDosesRequired: 20
            )
        }

        measure {
            _ = dataController.getFirstMed()
        }
    }

    func testHasRelationshipPerformance() throws {
        // INFO: Create a significant amount of test data
        for _ in 1 ... 25 {
            try dataController.createSampleData(
                appStore: false,
                medsRequested: 20,
                medDosesRequired: 20
            )
        }

        let fetchRequest = NSFetchRequest<Med>(entityName: "Med")
        let items = try dataController.container.viewContext.fetch(fetchRequest)

        measure {
            _ = items.filter(dataController.hasRelationship)
        }
    }

    func testAnyRelationshipPerformance() throws {
        // INFO: Create a significant amount of test data
        for _ in 1 ... 100 {
            try dataController.createSampleData(
                appStore: false,
                medsRequested: 20,
                medDosesRequired: 20
            )
        }

        let fetchRequest = NSFetchRequest<Med>(entityName: "Med")
        let items = try dataController.container.viewContext.fetch(fetchRequest)

        measure {
            _ = dataController.anyRelationships(for: items)
        }
    }
}
