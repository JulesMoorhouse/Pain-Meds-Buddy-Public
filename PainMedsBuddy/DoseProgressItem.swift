//
//  DoseProgressItem.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation
import SwiftUI

struct DoseProgressItem: Identifiable {
    let id = UUID()
    var size: CGFloat
    var elapsed: Int
    var remaining: Int
    var total: Int
    var labelMed: String
    var labelDose: String

    var progress: CGFloat {
        return CGFloat(elapsed) / CGFloat(total)
    }

    static var example: DoseProgressItem {
        let item = DoseProgressItem(
            size: 100,
            elapsed: 25,
            remaining: 75,
            total: 100,
            labelMed: "Paracetomol",
            labelDose: "2 x 300mg Pill"
        )

        return item
    }
}
