//
//  PresentableToastModel.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

class PresentableToastModel: ObservableObject {
    let id = UUID()
    var data: ToastModel
    var show = false

    init() {
        data = ToastModel(type: .info, message: "")
        show = false
    }

    init(type: ToastModel.ToastType, message: String = "") {
        data = ToastModel(type: type, message: message)
        show = false
    }
}
