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
                Section {
                    Button(action: {
                        navigation.pushView(
                            AcknowledgementsList()
                                .navigationTitle(Strings.settingsAcknowledgements.rawValue),
                            animated: true
                        )

                    }, label: {
                        HStack {
                            Text(.settingsAcknowledgements)
                                .foregroundColor(Color.primary)

                            Spacer()

                            ChevronRightView()
                        }
                        .accessibilityElement()
                        .accessibility(addTraits: .isButton)
                        .accessibilityIdentifier(.settingsAcknowledgements)
                    })
                }
                Section {
                    Button(Strings.settingsAddExampleData.rawValue) {
                        try? dataController.deleteIterateAll()
                        try? dataController.createSampleData()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                Section {
                    Button(Strings.settingsDeleteAllData.rawValue) {
                        try? dataController.deleteIterateAll()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle(Strings.tabTitleSettings.rawValue)
            .navigationBarAccessibilityIdentifier(.tabTitleSettings)
        }
        .iPadOnlyStackNavigationView()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
