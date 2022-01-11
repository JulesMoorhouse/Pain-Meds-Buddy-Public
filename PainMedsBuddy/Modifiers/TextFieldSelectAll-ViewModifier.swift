//
//  TextFieldSelectAll-ViewModifier.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

// swiftlint:disable identifier_name

import Combine
import SwiftUI

struct SelectAllTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                if let textField = obj.object as? UITextField {
                    textField.selectedTextRange = textField.textRange(
                        from: textField.beginningOfDocument,
                        to: textField.endOfDocument)
                }
            }
    }
}
