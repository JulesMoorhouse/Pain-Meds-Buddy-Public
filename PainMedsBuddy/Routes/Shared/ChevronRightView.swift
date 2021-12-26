//
//  ChevronRightView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct ChevronRightView: View {
    var body: some View {
        Image(systemName: "chevron.right")
            .font(.footnote)
            .foregroundColor(.secondary)
    }
}

struct ChevronRightView_Previews: PreviewProvider {
    static var previews: some View {
        ChevronRightView()
    }
}
