//
//  HomeRecentMedsView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct HomeRecentMedsView: View {
    let meds: [Med]

    var body: some View {
        Group {
            VStack(alignment: .leading) {
                HomeHeadingView(.homeRecentlyTaken)

                LazyVStack {
                    if !meds.isEmpty {
                        ForEach(meds, id: \.self) { med in
                            HomeMedRow(med: med)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(2)
                        }
                        .panelled()
                    } else {
                        EmptyRowView()
                    }
                }
            }
            .padding(.bottom)
        }
        .accessibilityIdentifier(!meds.isEmpty ? .homeRecentlyTaken : nil)
    }
}
