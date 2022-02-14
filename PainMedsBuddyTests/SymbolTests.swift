//
//  SymbolTests.swift
//  PainMedsBuddyTests
//
//  Created by Jules Moorhouse.
//

import CoreData
@testable import PainMedsBuddy
import SwiftUI
import XCTest

class SymbolTests: BaseTestCase {
    let symbols = SymbolModel.allSymbols

    func testSymbolIDMatchesName() {
        for symbol in symbols {
            XCTAssertEqual(symbol.id, symbol.name, "Symbol ID should always match its name.")
        }
    }

    func testSymbolsLabelsValid() {
        let symbols = SymbolModel.allSymbols

        for item in symbols {
            let image: Image? = UIImage(systemName: item.name)
                .map { _ in Image(systemName: item.name) }

            XCTAssertNotNil(image, "Symbols.json - An item which contains an invalid SF Symbol - \(item.name)")
        }
    }
}
