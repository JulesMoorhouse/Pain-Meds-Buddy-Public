//
//  PresentableToast.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

class PresentableToast: ObservableObject {
    let id = UUID()
    var data: ToastData
    var show = false

    init() {
        data = ToastData(type: .info, message: "")
        show = false
    }

    init(type: ToastData.ToastType, message: String = "") {
        data = ToastData(type: type, message: message)
        show = false
    }
}
