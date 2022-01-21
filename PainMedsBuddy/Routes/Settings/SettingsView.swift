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

    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .deleteConfirmation

    enum ActiveAlert {
        case deleteConfirmation, exampleDataConfirmation, crashReportTestConfirmation
    }

    var body: some View {
        NavigationViewChild {
            ZStack {
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
                                animated: true)

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
                            activeAlert = .exampleDataConfirmation
                            showAlert.toggle()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }

                    Section {
                        Button(Strings.settingsDeleteAllData.rawValue) {
                            activeAlert = .deleteConfirmation
                            showAlert.toggle()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }

                    Section {
                        Button(Strings.settingsGenerateTestCrash.rawValue) {
                            activeAlert = .crashReportTestConfirmation
                            showAlert.toggle()
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
        }
        .alert(isPresented: $showAlert) { alertOption() }
        .onAppear(perform: {
            self.tabBarHandler.showTabBar()
        })
    }

    func alertOption() -> Alert {
        switch activeAlert {
        case .deleteConfirmation:
            return Alert(
                title: Text(.settingsDeleteAllAlertTitle),
                message: Text(.settingsAreYouSureDeleteAll),
                primaryButton: .default(
                    Text(.commonDelete),
                    action: {
                        try? dataController.deleteIterateAll()
                    }),
                secondaryButton: .cancel())
        case .exampleDataConfirmation:
            return Alert(
                title: Text(.settingsExampleDataAlertTitle),
                message: Text(.settingsAreYouSureExampleData),
                primaryButton: .default(
                    Text(.commonOK),
                    action: {
                        try? dataController.deleteIterateAll()
                        try? dataController.createSampleData(appStore: false)
                    }),
                secondaryButton: .cancel())
        case .crashReportTestConfirmation:
            return Alert(
                title: Text(.settingsCrashTestAlertTitle),
                message: Text(.settingsAreYouSureCrashTest),
                primaryButton: .default(
                    Text(.commonOK),
                    action: {
                        Crashes.generateTestCrash()
                    }),
                secondaryButton: .cancel())
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
