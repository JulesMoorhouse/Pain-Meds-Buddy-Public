//
//  PlaceholderView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct PlaceholderView: View {
    let text: LocalizedStringKey
    let imageString: String

    var body: some View {
        VStack {
            Image(systemName: imageString)
                .foregroundColor(.secondary)
                .font(.system(size: 60))
            Spacer()
                .frame(height: 20)
            Text(text)
                .foregroundColor(.secondary)
        }
    }
}

struct PlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderView(text: Strings.commonEmptyView.rawValue, imageString: "pills")
    }
}
