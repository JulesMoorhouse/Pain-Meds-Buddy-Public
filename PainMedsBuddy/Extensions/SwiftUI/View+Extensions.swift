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
        _ localisedString: Strings) -> ModifiedContent<Self, AccessibilityAttachmentModifier>
    {
        let output = NSLocalizedString(
            localisedString.rawValue.stringKey,
            comment: ""
        )

        return accessibilityLabel(output)
    }

    func accessibilityLabel(
        _ localisedString: Strings,
        values: [String]
    ) -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        let output = String(format: NSLocalizedString(
            localisedString.rawValue.stringKey,
            comment: ""
        ),
        arguments: values)

        return accessibilityLabel(output)
    }

    func accessibilityIdentifier(
        _ identifier: Strings?
    ) -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        if let id = identifier {
            return accessibilityIdentifier(id.automatedId())
        }
        return accessibilityIdentifier("")
    }
}
