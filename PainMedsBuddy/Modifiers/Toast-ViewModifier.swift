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
    @Binding var data: ToastData

    private let toastOptions = SimpleToastOptions(
        alignment: .bottom,
        hideAfter: 5,
        showBackdrop: false
    )

    var icon: String {
        switch data.type {
        case .info:
            return SFSymbol.exclamationMarkTriangleFill.systemName
        case .success:
            return SFSymbol.checkmarkCircleFill.systemName
        }
    }

    var backgroundColor: Color {
        switch data.type {
        case .info:
            return Color.blue.opacity(0.8)
        case .success:
            return Color.green.opacity(0.8)
        }
    }

    func body(content: Content) -> some View {
        content
            .simpleToast(isPresented: $show, options: toastOptions) {
                HStack {
                    Image(systemName: icon)
                    Text(String(data.message))
                        .font(.caption)
                        .bold()
                }
                .padding()
                .background(backgroundColor)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .padding(.vertical, 5)
            }
    }
}

extension View {
    func toasted(show: Binding<Bool>,
                 data: Binding<ToastData>) -> some View
    {
        modifier(Toast(
            show: show,
            data: data
        ))
    }
}
