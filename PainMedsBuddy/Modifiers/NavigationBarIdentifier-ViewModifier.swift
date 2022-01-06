//
//  NavigationBarIdentifier-ViewModifier.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct NavigationBarIdentifier: ViewModifier {
    var identifier: String

    func body(content: Content) -> some View {
        content
            .background(
                NavigationBarAccessor {
                    $0?.accessibilityIdentifier = identifier
                }
            )
    }
}

extension View {
    func navigationBarAccessibilityIdentifier(
        _ identifier: Strings
    ) -> some View {
        modifier(NavigationBarIdentifier(identifier: identifier.automatedId()))
    }
}
