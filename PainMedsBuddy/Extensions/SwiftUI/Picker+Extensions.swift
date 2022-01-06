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
        _ localisedString: Strings,
        selection: Binding<SelectionValue>,
        @ViewBuilder content: () -> Content
    ) {
        let output = NSLocalizedString(
            localisedString.rawValue.stringKey,
            comment: ""
        )

        self.init(output, selection: selection, content: content)
    }
}
