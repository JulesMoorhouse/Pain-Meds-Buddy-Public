//
//  SettingsAdvancedView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct SettingsAdvancedView: View {
    @SceneStorage("defaultRemindMe") var defaultRemindMe: Bool = true

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var dataController: DataController
    @EnvironmentObject private var presentableToast: PresentableToastModel

    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .deleteConfirmation
    @State private var errorMessage = ""
    @State private var navigationButtonId = UUID()

    enum ActiveAlert {
        case deleteConfirmation,
             deleteHistoryConfirmation,
             deleteFailed,
             deleteHistoryFailed
    }

    var body: some View {
        NavigationViewChild {
            ZStack {
                Form {
                    Section(footer: Text(Strings.settingsDefaultRemindMeFooter)) {
                        Toggle(Strings.settingsDefaultRemindMe.rawValue,
                               isOn: $defaultRemindMe)
                    }

                    Section {
                        Button(Strings.settingsDeleteAllHistoryData.rawValue) {
                            activeAlert = .deleteHistoryConfirmation
                            showAlert.toggle()
                        }
                        .accentColor(.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }

                    Section {
                        Button(Strings.settingsDeleteAllData.rawValue) {
                            activeAlert = .deleteConfirmation
                            showAlert.toggle()
                        }
                        .accentColor(.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationBarTitle(Strings.settingsAdvanced.rawValue, displayMode: .inline)
            .navigationBarAccessibilityIdentifier(.settingsAdvanced)
            .navigationBarItems(leading:
                VStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text(.commonClose)
                    })
                }
                .id(self.navigationButtonId) // NOTE: Force new instance creation
            )
        }
        .toasted(show: $presentableToast.show, data: $presentableToast.data)
        .alert(isPresented: $showAlert) { alertOption() }
        .onRotate { _ in
            self.navigationButtonId = UUID()
        }
    }

    // MARK: -

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
                            self.presentableToast.data
                                = ToastModel(
                                    type: .success,
                                    message: String(.settingsDeleteAllDataCompleted)
                                )
                            self.presentableToast.show = true
                        } catch {
                            errorMessage = error.localizedDescription
                            activeAlert = .deleteFailed
                            showAlert.toggle()
                        }
                    }
                ),
                secondaryButton: .cancel()
            )
        case .deleteHistoryConfirmation:
            return Alert(
                title: Text(.settingsDeleteAllHistoryAlertTitle),
                message: Text(.settingsAreYouSureDeleteAllHistory),
                primaryButton: .default(
                    Text(.commonDelete),
                    action: {
                        do {
                            try dataController.deleteAllDoseHistory()
                            self.presentableToast.data
                                = ToastModel(
                                    type: .success,
                                    message: String(.settingsDeleteAllHistoryDataCompleted)
                                )
                            self.presentableToast.show = true
                        } catch {
                            errorMessage = error.localizedDescription
                            activeAlert = .deleteHistoryFailed
                            showAlert.toggle()
                        }
                    }
                ),
                secondaryButton: .cancel()
            )
        case .deleteFailed, .deleteHistoryFailed:
            let title = activeAlert == .deleteFailed
                ? Strings.settingsDeleteAllAlertTitle
                : activeAlert == .deleteHistoryFailed
                ? Strings.settingsDeleteAllHistoryAlertTitle
                : Strings.nothing

            return Alert(
                title: Text(title),
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
