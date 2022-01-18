//
//  PresentableToast.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

class PresentableToast: ObservableObject {
    let id = UUID()
    var med: Med
    var show = false

    init(med: Med) {
        self.med = med
        self.show = false
    }
}
