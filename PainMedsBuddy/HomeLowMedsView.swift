//
//  HomeLowMedsView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI
import XNavigation

struct HomeLowMedsView: View {
    @EnvironmentObject var navigation: Navigation

    let meds: FetchedResults<Med>

    var items: [Med] {
        DataController.resultsToArray(meds).allMeds
    }

    let listRows = 3

    var body: some View {
        Group {
            if lowMeds().count == 0 {
                EmptyView()
            } else {
                VStack(alignment: .leading) {
                    Text(.homeMedsRunningOut)
                        .foregroundColor(.secondary)

                    ForEach(lowMeds(), id: \.self) { med in
                        Button(action: {
                            navigation.pushView(
                                MedEditView(med: med, add: false),
                                animated: true
                            )
                        }) {
                            HStack {
                                MedRowView(med: med)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                ChevronRightView()

                                Spacer()
                                    .frame(width: 10)
                            }
                            .padding(2)
                        }
                    }
                    .panelled()
                }
            }
        }
    }

    func lowMeds() -> [Med] {
        let temp = items.sortedItems(using: .remaining)
        return temp.prefix(listRows).map { $0 }
    }
}

// struct HomeLowMedsView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeLowMedsView(meds: [Med.example])
//    }
// }
