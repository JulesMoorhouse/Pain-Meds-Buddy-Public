//
//  DatePicker+Extensions.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation
import SwiftUI

extension DatePicker where Label == Text {
    init(
        _ localisedString: Strings,
        selection: Binding<Date>,
        displayedComponents: DatePicker<Label>.Components
    ) {
        let output = NSLocalizedString(
            localisedString.rawValue.stringKey,
            comment: ""
        )

        self.init(
            output,
            selection: selection,
            in: ...Date(),
            displayedComponents: displayedComponents
        )
    }
}
