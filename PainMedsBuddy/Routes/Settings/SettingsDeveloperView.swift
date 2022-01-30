//
//  SettingsDeveloperView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import AppCenterCrashes
import SwiftUI
import XNavigation

struct SettingsDeveloperView: View, DestinationView {
    var navigationBarTitleConfiguration = NavigationBarTitleConfiguration(
        title: String(.settingsDeveloper),
        displayMode: .automatic
    )

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var dataController: DataController
    @EnvironmentObject var tabBarHandler: TabBarHandler
    @EnvironmentObject private var presentableToast: PresentableToast

    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .exampleDataConfirmation

    enum ActiveAlert {
        case exampleDataConfirmation, crashReportTestConfirmation
    }

    var body: some View {
        ZStack {
            Form {
                Section {
                    Button(Strings.settingsAddExampleData.rawValue) {
                        activeAlert = .exampleDataConfirmation
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
            }
        }
        .navigationBarTitle(configuration: navigationBarTitleConfiguration)
        .navigationBarAccessibilityIdentifier(.settingsDeveloper)
        .alert(isPresented: $showAlert) { alertOption() }
        .toasted(show: $presentableToast.show, message: $presentableToast.message)
        .onAppear(perform: {
            self.tabBarHandler.hideTabBar()
        })
        .onDisappear(perform: {
            self.tabBarHandler.showTabBar()
        })
    }

    func alertOption() -> Alert {
        switch activeAlert {
        case .exampleDataConfirmation:
            return Alert(
                title: Text(.settingsExampleDataAlertTitle),
                message: Text(.settingsAreYouSureExampleData),
                primaryButton: .default(
                    Text(.commonOK),
                    action: {
                        try? dataController.deleteIterateAll()
                        try? dataController.createSampleData(appStore: false)
                    }
                ),
                secondaryButton: .cancel()
            )
        case .crashReportTestConfirmation:
            return Alert(
                title: Text(.settingsCrashTestAlertTitle),
                message: Text(.settingsAreYouSureCrashTest),
                primaryButton: .default(
                    Text(.commonOK),
                    action: {
                        Crashes.generateTestCrash()
                    }
                ),
                secondaryButton: .cancel()
            )
        }
    }
}

struct SettingsDeveloperView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsDeveloperView()
    }
}
