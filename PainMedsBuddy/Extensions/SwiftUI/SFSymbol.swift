//
//  SFSymbol.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

enum SFSymbol: String, CaseIterable {
    case arrowTriangle2CirclePath = "arrow.triangle.2.circlepath"
    case arrowUpArrowDown = "arrow.up.arrow.down"
    case checkmark
    case checkmarkCircle = "checkmark.circle"
    case chevronRight = "chevron.right"
    case eyeDropperHalfFull = "eyedropper.halffull"
    case exclamationMarkTriangle = "exclamationmark.triangle"
    case gearShapeFill = "gearshape.fill"
    case house
    case infoCircle = "info.circle"
    case pills
    case pillsFill = "pills.fill"
    case plus
    case xMark = "xmark"

    var systemName: String { rawValue }
}

extension Image {
    init(symbol: SFSymbol) {
        self.init(systemName: symbol.rawValue)
    }
}
