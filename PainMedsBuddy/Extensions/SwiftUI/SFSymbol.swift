//
//  SFSymbol.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

enum SFSymbol: String, CaseIterable {
    case arrowUpArrowDown = "arrow.up.arrow.down"
    case booksVerticalFill = "books.vertical.fill"
    case clockArrowCirclePath = "clock.arrow.circlepath"
    case checkmark
    case checkmarkCircle = "checkmark.circle"
    case checkmarkSquare = "checkmark.square"
    case chevronDown = "chevron.down"
    case chevronRight = "chevron.right"
    case chevronUp = "chevron.up"
    case eyeDropperHalfFull = "eyedropper.halffull"
    case exclamationMarkTriangle = "exclamationmark.triangle"
    case gearShapeFill = "gearshape.fill"
    case house
    case infoCircle = "info.circle"
    case lockFill = "lock.fill"
    case pills
    case pillsFill = "pills.fill"
    case plus
    case squareDashed = "square.dashed"
    case timer
    case xMark = "xmark"

    var systemName: String { rawValue }
}

extension Image {
    init(symbol: SFSymbol) {
        self.init(systemName: symbol.rawValue)
    }
}
