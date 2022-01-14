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

    var body: some View {
        Group {
            if meds.isEmpty {
                EmptyView()
            } else {
                VStack(alignment: .leading) {
                    Text(.homeMedsRunningOut)
                        .foregroundColor(.secondary)

                    LazyVStack {
                        ForEach(meds, id: \.self) { med in
                            Button(action: {
                                navigation.pushView(
                                    MedEditView(
                                        dataController: dataController,
                                        med: med,
                                        add: false,
                                        hasRelationship: dataController.hasRelationship(for: med)
                                    ),
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
        .accessibilityIdentifier(!meds.isEmpty ? .homeMedsRunningOut : nil)
    }
}

// struct HomeLowMedsView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeLowMedsView(meds: [Med.example])
//    }
// }
