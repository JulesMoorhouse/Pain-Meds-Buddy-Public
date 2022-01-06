//
//  AssetTest.swift
//  PainMedsBuddyTests
//
//  Created by Jules Moorhouse.
//

@testable import PainMedsBuddy
import XCTest

class AssetTest: XCTestCase {
    func testColoursExist() {
        for colour in Med.colours {
            XCTAssertNotNil(UIColor(named: colour), "Failed to load colour '\(colour)' from asset catalog.")
        }
    }

    func testJSONLoadsCorrectly() {
        XCTAssertFalse(Symbol.allSymbols.isEmpty, "Failed to load symbols from JSON")
    }
}
