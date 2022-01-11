//
//  DoseTests.swift
//  PainMedsBuddyTests
//
//  Created by Jules Moorhouse.
//

import CoreData
@testable import PainMedsBuddy
import XCTest

class DoseTests: BaseTestCase {
    func testCreatingDosesAndMeds() {
        let targetCount = 10

        for _ in 0 ..< targetCount {
            let med = Med(context: managedObjectContext)

            for _ in 0 ..< targetCount {
                let dose = Dose(context: managedObjectContext)
                dose.med = med
            }
        }

        XCTAssertEqual(dataController.count(for: Med.fetchRequest()), targetCount)
        XCTAssertEqual(dataController.count(for: Dose.fetchRequest()), targetCount * targetCount)
    }
}
