//
//  Picker+Extensions.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation
import SwiftUI

extension Picker where Label == Text {
    init(
        _ localizedString: Strings,
        selection: Binding<SelectionValue>,
        @ViewBuilder content: () -> Content) {
        let output = NSLocalizedString(
            localizedString.rawValue.stringKey,
            comment: ""
        )

        self.init(output, selection: selection, content: content)
    }
}
