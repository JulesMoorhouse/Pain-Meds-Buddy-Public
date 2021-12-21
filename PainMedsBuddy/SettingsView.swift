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
                        .navigationTitle(.settingsAcknowledgements),
                    label: {
                        Text(.settingsAcknowledgements)

                    })

                Button(.settingsAddExampleData) {
                    dataController.deleteAll()
                    try? dataController.createSampleData()
                }

                Button(.settingsDeleteAllData) {
                    dataController.deleteAll()
                }
            }
            .navigationTitle(.tabTitleSettings)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
