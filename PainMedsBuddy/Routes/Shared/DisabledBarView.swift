//
//  DisabledBarView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct DisabledBarView: View {
    var body: some View {
        Rectangle()
            .fill(Color.semiDisabledBackground)
            .frame(height: 10)
    }
}

struct DisabledBarView_Previews: PreviewProvider {
    static var previews: some View {
        DisabledBarView()
    }
}
