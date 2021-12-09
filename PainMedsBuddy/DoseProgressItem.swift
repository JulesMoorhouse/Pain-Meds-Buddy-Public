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
    var count: Int
    var total: Int
    var labelMed: String
    var labelDose: String

    var progress: CGFloat {
        return CGFloat(count) / CGFloat(total)
    }

    static var example: DoseProgressItem {
        let item = DoseProgressItem(
            size: 100,
            count: 25,
            total: 100,
            labelMed: "Paracetomol",
            labelDose: "2 x 300mg Pill"
        )

        return item
    }
}
