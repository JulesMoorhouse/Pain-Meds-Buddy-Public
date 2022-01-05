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
    @EnvironmentObject var dataController: DataController

    let meds: [Med]

    var items: [Med] {
        meds.allMeds
    }

    let listRows = 3

    var body: some View {
        Group {
            if lowMeds().isEmpty {
                EmptyView()
            } else {
                VStack(alignment: .leading) {
                    Text(.homeMedsRunningOut)
                        .foregroundColor(.secondary)

                    LazyVStack {
                        ForEach(lowMeds(), id: \.self) { med in
                            Button(action: {
                                navigation.pushView(
                                    MedEditView(
                                        med: med,
                                        add: false,
                                        hasRelationship: dataController.hasRelationship(for: med)),
                                    animated: true
                                )
                            }, label: {
                                HStack {
                                    MedRowView(med: med)
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    Spacer()
                                        .frame(width: 10)
                                }
                                .padding(2)
                            })
                                .panelled()
                        }
                    }
                }
            }
        }
        .accessibilityIdentifier(!lowMeds().isEmpty ? .homeMedsRunningOut : nil)
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
