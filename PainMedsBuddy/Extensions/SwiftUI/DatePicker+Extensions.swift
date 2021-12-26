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
        _ localizedString: Strings,
        selection: Binding<Date>,
        displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]
    ) {
        let output = NSLocalizedString(
            localizedString.rawValue.stringKey,
            comment: ""
        )

        self.init(output, selection: selection, displayedComponents: displayedComponents)
    }
}
