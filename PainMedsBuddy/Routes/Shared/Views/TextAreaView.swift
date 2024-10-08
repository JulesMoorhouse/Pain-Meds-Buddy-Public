//
//  TextAreaView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct TextArea: View {
    private let placeholder: LocalizedStringKey
    @Binding var text: String

    var body: some View {
        TextEditor(text: $text)
            .background(
                HStack(alignment: .top) {
                    if text.isBlank {
                        Text(placeholder)
                    } else {
                        Text("")
                    }

                    Spacer()
                }
                .foregroundColor(Color.primary.opacity(0.25))
                .padding(EdgeInsets(top: 0, leading: 4, bottom: 7, trailing: 0))
            )
    }

    init(_ placeholder: LocalizedStringKey, text: Binding<String>) {
        self.placeholder = placeholder
        _text = text
    }
}

extension String {
    var isBlank: Bool {
        allSatisfy(\.isWhitespace)
    }
}

struct TextAreaView_Previews: PreviewProvider {
    static var previews: some View {
        TextArea("Add some text here", text: .constant(""))
    }
}
