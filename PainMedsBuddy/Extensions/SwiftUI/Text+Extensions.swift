//
//  Text+Extensions.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation
import SwiftUI

extension Text {
    init(_ localizedString: Strings) {
        self.init(localizedString.rawValue)
    }

    init(_ localizedString: Strings, values: [String]) {
        let output = String(format: NSLocalizedString(
            localizedString.rawValue.stringKey,
            comment: ""
        ), arguments: values)

        self.init(output)
    }

    init(_ localizedString: Strings, comment: StaticString) {
        self.init(
            localizedString.rawValue,
            tableName: nil,
            bundle: nil,
            comment: comment
        )
    }
}
