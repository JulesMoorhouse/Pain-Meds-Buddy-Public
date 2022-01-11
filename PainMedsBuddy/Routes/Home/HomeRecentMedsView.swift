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
            if meds.isEmpty {
                EmptyView()
            } else {
                VStack(alignment: .leading) {
                    Text(.homeRecentlyTaken)
                        .foregroundColor(.secondary)

                    LazyVStack {
                        ForEach(meds, id: \.self) { med in
                            HomeMedRow(med: med)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(2)
                        }
                        .panelled()
                    }
                }
                .padding(.bottom)
            }
        }
        .accessibilityIdentifier(!meds.isEmpty ? .homeRecentlyTaken : nil)
    }
}

// struct HomeRecentMedsView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeRecentMedsView(meds: [Med.example])
//    }
// }
