//
//  ToastData.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct ToastData {
    enum ToastType {
        case info, success
    }

    let type: ToastType
    let message: String
}
