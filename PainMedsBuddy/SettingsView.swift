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

    var body: some View {
        NavigationView {
            Form {
                NavigationLink(destination:
                    AcknowledgementsList()
                        .navigationTitle("Acknowledgements"),
                    label: {
                        Text("Acknowledgements")

                    })
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
