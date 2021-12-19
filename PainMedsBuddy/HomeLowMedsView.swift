//
//  HomeLowMedsView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct HomeLowMedsView: View {
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
                    Text("Meds running out")
                        .foregroundColor(.secondary)

                    ForEach(lowMeds(), id: \.self) { med in
                        NavigationLink(destination: MedEditView(med: med, add: false)) {
                            HStack {
                                MedRowView(med: med)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Image(systemName: "chevron.right")
                                    .font(.body)

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
