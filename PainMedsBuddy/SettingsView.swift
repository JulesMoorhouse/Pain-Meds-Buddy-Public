//
//  SettingsView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import AckGenUI
import SwiftUI
import XNavigation

struct SettingsView: View {
    static let SettingsTag: String? = "Settings"

    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var navigation: Navigation

    var body: some View {
        NavigationView {
            Form {
                Button(action: {
                    navigation.pushView(
                        AcknowledgementsList()
                            .navigationTitle(Strings.settingsAcknowledgements.rawValue), animated: true
                    )
                }) {
                    HStack {
                        Text(.settingsAcknowledgements)
                            .foregroundColor(Color.primary)

                        Spacer()

                        ChevronRightView()
                    }
                }

                Button(Strings.settingsAddExampleData.rawValue) {
                    dataController.deleteAll()
                    try? dataController.createSampleData()
                }

                Button(Strings.settingsDeleteAllData.rawValue) {
                    dataController.deleteAll()
                }
            }
            .navigationTitle(Strings.tabTitleSettings.rawValue)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
