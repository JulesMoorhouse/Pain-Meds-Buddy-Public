//
//  Toast-ViewModifier.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation
import SimpleToast
import SwiftUI

struct Toast: ViewModifier {
    @Binding var show: Bool
    @Binding var message: String

    private let toastOptions = SimpleToastOptions(
        alignment: .bottom,
        hideAfter: 5,
        showBackdrop: false)

    func body(content: Content) -> some View {
        content
            .simpleToast(isPresented: $show, options: toastOptions) {
                HStack {
                    Image(systemName: SFSymbol.exclamationMarkTriangle.systemName)
                    Text(String(message))
                        .font(.caption)
                }
                .padding()
                .background(Color.blue.opacity(0.8))
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .padding(.vertical, 5)
            }
    }
}

extension View {
    func toasted(show: Binding<Bool>, message: Binding<String>) -> some View {
        modifier(Toast(show: show, message: message))
    }
}
