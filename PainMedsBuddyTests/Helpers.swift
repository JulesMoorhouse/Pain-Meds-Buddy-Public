//
//  Helpers.swift
//  PainMedsBuddyTests
//
//  Created by Jules Moorhouse.
//

import Foundation
@testable import PainMedsBuddy
import XCTest

class Helpers: XCTestCase {
    // INFO: Usage let string = Helpers().localisedString(.commonBasicSettings)
    func localisedString(_ param: Strings) -> String {
        let reference = type(of: self)
        let bundle = Bundle(for: reference)
        let string = Foundation.NSLocalizedString(
            String(.commonBasicSettings),
            tableName: nil,
            bundle: bundle,
            comment: "")

        return string
    }
}
