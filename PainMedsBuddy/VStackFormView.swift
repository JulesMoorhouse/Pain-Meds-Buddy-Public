//
//  VStackFormView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct VStackFormView<Content: View>: View {
    let useForm: Bool
    @ViewBuilder var content: Content

    var body: some View {
        if useForm {
            Form {
                content
            }
        } else {
            VStack(alignment: .leading) {
                content
            }
        }
    }
}

struct VStackFormView_Previews: PreviewProvider {
    static var previews: some View {
        VStackFormView(useForm: true) {
            EmptyView()
        }
    }
}
