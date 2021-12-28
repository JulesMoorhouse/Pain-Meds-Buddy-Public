//
//  SymbolTests.swift
//  PainMedsBuddyTests
//
//  Created by Jules Moorhouse.
//

import CoreData
@testable import PainMedsBuddy
import XCTest

class SymbolTests: BaseTestCase {
    let symbols = Symbol.allSymbols

    func testSymbolIDMatchesName() {
        for symbol in symbols {
            XCTAssertEqual(symbol.id, symbol.name, "Symbol ID should always match its name.")
        }
    }
}
