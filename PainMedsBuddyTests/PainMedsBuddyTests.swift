//
//  PainMedsBuddyTests.swift
//  PainMedsBuddyTests
//
//  Created by Jules Moorhouse.
//

import CoreData
@testable import PainMedsBuddy
import XCTest

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
