//
//  HomeHeadingView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct HomeHeadingView: View {
    let label: Strings

    var body: some View {
        Text(label)
            .bold()
            .textCase(.uppercase)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(5)
            .foregroundColor(.secondary.opacity(0.3))
            .background(Color.primary.opacity(0.03))
            .overlay(Divider(), alignment: .bottom)
    }

    init(_ label: Strings) {
        self.label = label
    }
}

struct HomeHeadingView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeadingView(.homeCurrentMeds)
    }
}
