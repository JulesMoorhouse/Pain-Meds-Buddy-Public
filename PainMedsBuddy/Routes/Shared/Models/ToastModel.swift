//
//  ToastModel.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct ToastModel {
    enum ToastType {
        case info, success
    }

    let type: ToastType
    let message: String
}
