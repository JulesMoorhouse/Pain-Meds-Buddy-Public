//
//  SettingsAdvancedView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI
import XNavigation

struct SettingsAdvancedView: View, DestinationView {
    var navigationBarTitleConfiguration = NavigationBarTitleConfiguration(
        title: String(.settingsAdvanced),
        displayMode: .automatic
    )

    @SceneStorage("defaultRemindMe") var defaultRemindMe: Bool = true

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var dataController: DataController
    @EnvironmentObject var tabBarHandler: TabBarHandler
    @EnvironmentObject private var presentableToast: PresentableToast

    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .deleteConfirmation
    @State private var errorMessage = ""

    enum ActiveAlert {
        case deleteConfirmation, deleteFailed
    }

    var body: some View {
        ZStack {
            Form {
                Section { }

                Section(footer: Text(Strings.settingsDefaultRemindMeFooter)) {
                    Toggle(Strings.settingsDefaultRemindMe.rawValue,
                           isOn: $defaultRemindMe)
                }

                Section {
                    Button(Strings.settingsDeleteAllData.rawValue) {
                        activeAlert = .deleteConfirmation
                        showAlert.toggle()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .navigationBarTitle(configuration: navigationBarTitleConfiguration)
        .navigationBarAccessibilityIdentifier(.settingsAdvanced)
        .toasted(show: $presentableToast.show, data: $presentableToast.data)
        .alert(isPresented: $showAlert) { alertOption() }
        .onAppear(perform: {
            self.tabBarHandler.hideTabBar()
        })
        .onDisappear(perform: {
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
                        do {
                        try dataController.deleteIterateAll()
                        } catch {
                            errorMessage = error.localizedDescription
                            activeAlert = .deleteFailed
                            showAlert.toggle()
                        }
                    }
                ),
                secondaryButton: .cancel()
            )
        case .deleteFailed:
            return Alert(
                title: Text(.settingsDeleteAllAlertTitle),
                message: Text(InterpolatedStrings
                    .commonErrorMessage(
                        error: errorMessage)),
                dismissButton:
                .default(
                    Text(.commonOK)
                )
            )
        }
    }
}

struct SettingsAdvancedView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsAdvancedView()
    }
}
