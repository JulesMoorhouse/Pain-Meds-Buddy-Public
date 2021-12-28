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
        // Create a significant amount of test data
        for _ in 1...100 {
            try dataController.createSampleData()
        }

        measure {
            _ = dataController.getFirstMed()
        }
    }

    func testHasRelationshipPerformance() throws {
        // Create a significant amount of test data
        for _ in 1...100 {
            try dataController.createSampleData()
        }

        let fetchRequest = NSFetchRequest<Med>(entityName: "Med")
        let items = try dataController.container.viewContext.fetch(fetchRequest)

        measure {
            _ = items.filter(dataController.hasRelationship)
        }
    }

    func testAnyRelationshipPerformance() throws {
        // Create a significant amount of test data
        for _ in 1...100 {
            try dataController.createSampleData()
        }

        let fetchRequest = NSFetchRequest<Med>(entityName: "Med")
        let items = try dataController.container.viewContext.fetch(fetchRequest)

        measure {
            _ = dataController.anyRelationships(for: items)
        }
    }
}
