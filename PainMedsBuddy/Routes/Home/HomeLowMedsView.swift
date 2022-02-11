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
            VStack(alignment: .leading) {
                HomeHeadingView(.homeMedsRunningOut)

                LazyVStack {
                    if !meds.isEmpty {
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
                            .accessibilityElement(children: .ignore)
                            .accessibilityAddTraits(.isButton)
                            .accessibilityIdentifier(.homeAccessibilityIconRemainingEdit)
                            .accessibilityLabel(
                                InterpolatedStrings.homeAccessibilityIconRemainingEdit(med: med)
                            )
                        }
                    } else {
                        EmptyRowView()
                    }
                }
            }
        }
        .accessibilityIdentifier(!meds.isEmpty ? .homeMedsRunningOut : nil)
    }
}
