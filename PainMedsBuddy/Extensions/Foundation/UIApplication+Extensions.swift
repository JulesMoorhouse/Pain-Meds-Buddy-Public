//
//  UIApplication+Extensions.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import UIKit

extension UIApplication {
    static func endEditing() {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter { $0.isKeyWindow }.first
        keyWindow?.endEditing(true)
    }
}
