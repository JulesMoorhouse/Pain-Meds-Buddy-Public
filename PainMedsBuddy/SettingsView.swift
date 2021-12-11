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
                        .navigationTitle("Acknowledgements"),
                    label: {
                        Text("Acknowledgements")

                    })

                Button("Add Example Data") {
                    dataController.deleteAll()
                    try? dataController.createSampleData()
                }

                Button("Delete All Data") {
                    dataController.deleteAll()
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
