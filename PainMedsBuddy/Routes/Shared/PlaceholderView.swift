//
//  PlaceholderView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct PlaceholderView: View {
    let string: Strings
    let imageString: String

    var body: some View {
        VStack {
            Image(systemName: imageString)
                .foregroundColor(.secondary)
                .font(.system(size: 60))
            Spacer()
                .frame(height: 20)
            Text(String(string))
                .foregroundColor(.secondary)
                .accessibilityIdentifier(string)
        }
    }
}

struct PlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderView(
            string: Strings.commonEmptyView,
            imageString: SFSymbol.pills.systemName
        )
    }
}
