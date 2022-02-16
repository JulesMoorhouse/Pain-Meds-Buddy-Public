//
//  HomeLowMedsView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct HomeLowMedsView: View {
    @EnvironmentObject var dataController: DataController

    @State private var showSheet = false

    let meds: [Med]

    var body: some View {
        Group {
            VStack(alignment: .leading) {
                HomeHeadingView(.homeMedsRunningOut)

                LazyVStack {
                    if !meds.isEmpty {
                        ForEach(meds, id: \.self) { med in
                            Button(action: {
                                showSheet.toggle()
                            }, label: {
                                HStack {
                                    MedRowView(med: med)
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    Spacer()
                                        .frame(width: 10)
                                }
                                .padding(2)
                            })
                            .sheet(isPresented: $showSheet) {
                                MedEditView(
                                    dataController: dataController,
                                    med: med,
                                    add: false,
                                    hasRelationship: dataController.hasRelationship(for: med)
                                )
                            }
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
