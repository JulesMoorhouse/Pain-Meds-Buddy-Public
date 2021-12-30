//
//  ChevronRightView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct ChevronRightView: View {
    var body: some View {
        Image(systemName: SFSymbol.chevronRight.systemName)
            .font(.footnote)
            .foregroundColor(.secondary)
    }
}

struct ChevronRightView_Previews: PreviewProvider {
    static var previews: some View {
        ChevronRightView()
    }
}
