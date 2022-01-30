//
//  PresentableToast.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

class PresentableToast: ObservableObject {
    let id = UUID()
    var message = ""
    var show = false

    init(message: String = "") {
        self.message = message
        show = false
    }
}
