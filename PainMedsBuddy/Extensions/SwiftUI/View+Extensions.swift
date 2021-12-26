//
//  View+Extensions.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation
import SwiftUI

extension View {
    func navigationTitle(_ localizedString: Strings) -> some View {
        let output = NSLocalizedString(
            localizedString.rawValue.stringKey,
            comment: ""
        )

        return navigationBarTitle(output)
    }

    func accessibilityLabel(
        _ localizedString: Strings) -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        let output = NSLocalizedString(
            localizedString.rawValue.stringKey,
            comment: ""
        )

        return accessibilityLabel(output)
    }

    func accessibilityLabel(
        _ localizedString: Strings,
        values: [String]) -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        let output = String(format: NSLocalizedString(
            localizedString.rawValue.stringKey,
            comment: ""
        ),
        arguments: values)

        return accessibilityLabel(output)
    }
}
