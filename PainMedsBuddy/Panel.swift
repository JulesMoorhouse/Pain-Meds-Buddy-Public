//
//  Panel.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct Panel: ViewModifier {
    var cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(Color.secondarySystemGroupedBackground)
            .cornerRadius(cornerRadius)
            .shadow(color: Color.black.opacity(0.2), radius: 5)
    }
}

extension View {
    func panelled(cornerRadius: CGFloat = 5) -> some View {
        self.modifier(Panel(cornerRadius: cornerRadius))
    }
}
