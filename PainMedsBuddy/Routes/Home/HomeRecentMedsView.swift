//
//  HomeRecentMedsView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct HomeRecentMedsView: View {
    let doses: FetchedResults<Dose>
    let meds: FetchedResults<Med>

    var items: [Med] {
        DataController.resultsToArray(meds).allMeds
    }

    let listRows = 3

    var body: some View {
        Group {
            if canTakeMeds().isEmpty {
                EmptyView()
            } else {
                VStack(alignment: .leading) {
                    Text(.homeRecentlyTaken)
                        .foregroundColor(.secondary)

                    LazyVStack {
                        ForEach(canTakeMeds(), id: \.self) { med in
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
        .accessibilityIdentifier(!canTakeMeds().isEmpty ? .homeRecentlyTaken : nil)
    }

    func uniqueDoseMeds() -> [Med] {
        let uniqueDoseMeds = Array(Set(doses.filter { $0.med != nil }.compactMap(\.med)))
        return uniqueDoseMeds
    }

    func canTakeMeds() -> [Med] {
        // INFO" Get unique meds which are currently not elapsed
        var temp = items.filter { !uniqueDoseMeds().contains($0) }
        temp = temp.sortedItems(using: .lastTaken)
        return temp.prefix(listRows).map { $0 }
    }
}

// struct HomeRecentMedsView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeRecentMedsView(meds: [Med.example])
//    }
// }
