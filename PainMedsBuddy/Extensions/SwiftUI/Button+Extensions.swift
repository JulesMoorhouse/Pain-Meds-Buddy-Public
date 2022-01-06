//
//  Button+Extensions.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation
import SwiftUI

extension Button where Label == Text {
    init(_ localizedString: Strings, action: @escaping () -> Void) {
        let output = NSLocalizedString(
            localizedString.rawValue.stringKey,
            comment: ""
        )

        self.init(output, action: action)
    }
}
