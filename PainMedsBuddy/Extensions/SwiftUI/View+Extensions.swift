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

    func iPadOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom != .phone {
            return AnyView(navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }

    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    func hideKeyboardWhenTappedAround() -> some View {
        onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
        }
    }

    /// Sets the preferred display mode for SplitView within the environment of self.
    func splitViewPreferredDisplayMode(_ mode: UISplitViewController.DisplayMode) -> some View {
        environment(\.splitViewPreferredDisplayMode, mode)
    }

    /// Control if allow to dismiss the sheet by the user actions
    public func allowAutoDismiss(_ dismissible: @escaping () -> Bool) -> some View {
        background(ModalHackView(dismissible: dismissible))
    }

    /// Control if allow to dismiss the sheet by the user actions
    public func allowAutoDismiss(_ dismissible: Bool) -> some View {
        background(ModalHackView(dismissible: { dismissible }))
    }
}
