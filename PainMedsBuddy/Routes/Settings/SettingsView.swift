//
//  SettingsView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import AckGenUI
import AppCenterCrashes
import SwiftUI
import XNavigation

struct SettingsView: View {
    static let SettingsTag: String? = "Settings"

    @SceneStorage("defaultRemindMe") var defaultRemindMe: Bool = true

    @EnvironmentObject private var dataController: DataController
    @EnvironmentObject private var navigation: Navigation
    @EnvironmentObject private var tabBarHandler: TabBarHandler
    @EnvironmentObject private var presentableToast: PresentableToast

    var body: some View {
        NavigationViewChild {
            Form {
                Section {
                    Toggle(Strings.settingsDefaultRemindMe.rawValue,
                           isOn: $defaultRemindMe)
                }

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
                        try? dataController.createSampleData(appStore: false)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }

                Section {
                    Button(Strings.settingsDeleteAllData.rawValue) {
                        try? dataController.deleteIterateAll()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }

                Section {
                    Button(Strings.settingsGenerateTestCrash.rawValue) {
                        Crashes.generateTestCrash()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }

                Section(footer:
                    Text(Strings.settingsNoResponsibility)
                        .multilineTextAlignment(.center)
                ) {}
            }
            .navigationTitle(Strings.tabTitleSettings.rawValue)
            .navigationBarAccessibilityIdentifier(.tabTitleSettings)
            .toasted(show: $presentableToast.show, message: $presentableToast.message)
        }
        .iPadOnlyStackNavigationView()
        .onAppear(perform: {
            self.tabBarHandler.showTabBar()
        })
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
