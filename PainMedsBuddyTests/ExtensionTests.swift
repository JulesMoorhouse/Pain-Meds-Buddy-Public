//
//  ExtensionTests.swift
//  PainMedsBuddyTests
//
//  Created by Jules Moorhouse.
//

@testable import PainMedsBuddy
import XCTest

class ExtensionTests: XCTestCase {
    func testSequenceKeyPathSortingSelf() {
        let items = [1, 4, 3, 2, 5]
        let sortedItems = items.sorted(by: \.self)
        XCTAssertEqual(sortedItems, [1, 2, 3, 4, 5], "The sorted numbers must be ascending.")
    }
}
