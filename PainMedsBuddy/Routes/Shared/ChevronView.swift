//
//  ChevronView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct ChevronView: View {
    enum Direction {
        // swiftlint:disable:next identifier_name
        case right, bottom, up
    }

    let direction: Direction

    var icon: String {
        if direction == .right {
            return SFSymbol.chevronRight.systemName
        } else if direction == .up {
            return SFSymbol.chevronUp.systemName
        }
        return SFSymbol.chevronDown.systemName
    }

    var body: some View {
        Image(systemName: icon)
            .font(.footnote)
            .foregroundColor(.secondary)
    }

    init(direction: Direction = .right) {
        self.direction = direction
    }
}

struct ChevronRightView_Previews: PreviewProvider {
    static var previews: some View {
        ChevronView()
    }
}
