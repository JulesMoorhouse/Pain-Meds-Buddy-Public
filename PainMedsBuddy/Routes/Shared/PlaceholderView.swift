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
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .accessibilityIdentifier(string)
        }
        .padding(.horizontal, 25)
    }
}

struct PlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderView(
            string: .medEditHiddenTitle,
            imageString: SFSymbol.pills.systemName
        )
    }
}
