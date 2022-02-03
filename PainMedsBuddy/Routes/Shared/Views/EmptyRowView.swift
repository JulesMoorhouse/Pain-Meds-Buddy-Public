//
//  EmptyRowView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct EmptyRowView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.secondarySystemGroupedBackground)
                    .padding(2)
                    .panelled()

                VStack(alignment: .leading) {
                    DisabledBarView()
                        .frame(maxWidth: geometry.size.width * 0.5)
                        .padding(.bottom, 5)
                        .padding(.horizontal, 10)
                        .padding(.top, 10)

                    DisabledBarView()
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)
                }
            }
        }
        .frame(minHeight: 40)
    }
}

struct EmptyRowView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyRowView()
    }
}
