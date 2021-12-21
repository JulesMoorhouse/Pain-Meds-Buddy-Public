//
//  SettingsView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import AckGenUI
import SwiftUI

struct SettingsView: View {
    static let SettingsTag: String? = "Settings"

    @EnvironmentObject var dataController: DataController

    var body: some View {
        NavigationView {
            Form {
                NavigationLink(destination:
                    AcknowledgementsList()
                                .navigationTitle(Strings.settingsAcknowledgements.rawValue),
                    label: {
                        Text(.settingsAcknowledgements)

                    })

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
