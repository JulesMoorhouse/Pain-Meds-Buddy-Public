//
//  SettingsDeveloperView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import AppCenterCrashes
import SwiftUI

struct SettingsDeveloperView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var dataController: DataController
    @EnvironmentObject private var presentableToast: PresentableToastModel

    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .exampleDataConfirmation
    @State private var showRestore = false
    @State private var showBackup = false
    @State private var errorMessage = ""
    @State private var document: JsonFileDocument?
    @State private var navigationButtonId = UUID()

    enum ActiveAlert {
        case exampleDataConfirmation,
             crashReportTestConfirmation,
             restoreDataConfirmation,
             backupFailed,
             restoreFailed,
             exampleDataFailed
    }

    var defaultExportFileName: String {
        let appInitials = String(.commonAppNameInitials)
        return "\(appInitials)-\(Date().dateToFileString).json"
    }

    var body: some View {
        NavigationViewChild {
            ZStack {
                Form {
                    Section(footer:
                        Text(Strings.settingsBackupFooter)
                            .multilineTextAlignment(.center)
                    ) {
                        Button(Strings.settingsBackup.rawValue) {
                            do {
                                let data = try dataController.coreDataToJson()
                                document = JsonFileDocument(initialText: data)
                                showBackup = true
                            } catch {
                                errorMessage = error.localizedDescription
                                activeAlert = .backupFailed
                                showAlert.toggle()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    Section {
                        Button(Strings.settingsRestore.rawValue) {
                            activeAlert = .restoreDataConfirmation
                            showAlert.toggle()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
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
            .fileExporter(isPresented: $showBackup,
                          document: document,
                          contentType: .json,
                          defaultFilename: defaultExportFileName)
            { result in
                switch result {
                case .success(let url):
                    print("Saved to \(url)")
                    self.presentableToast.data
                        = ToastModel(
                            type: .success,
                            message: String(.settingsBackupCompletedMessage)
                        )
                    self.presentableToast.show = true
                case .failure(let error):
                    print(error.localizedDescription)
                    errorMessage = error.localizedDescription
                    activeAlert = .backupFailed
                    showAlert.toggle()
                }
            }
            .fileImporter(isPresented: $showRestore,
                          allowedContentTypes: [.json],
                          allowsMultipleSelection: false)
            { result in
                do {
                    guard let selectedFile: URL = try result.get().first else { return }
                    guard let input = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }
                    do {
                        try dataController.jsonToCoreData(input)
                        self.presentableToast.data
                            = ToastModel(
                                type: .success,
                                message: String(.settingsRestoreCompletedMessage)
                            )
                        self.presentableToast.show = true
                    } catch {
                        errorMessage = error.localizedDescription
                        activeAlert = .restoreFailed
                        showAlert.toggle()
                    }
                } catch {
                    // Handle failure.
                    print("Unable to read file contents")
                    print(error.localizedDescription)
                    errorMessage = error.localizedDescription
                    activeAlert = .restoreFailed
                    showAlert.toggle()
                }
            }
            .navigationBarTitle(Strings.settingsDeveloper.rawValue, displayMode: .inline)
            .navigationBarAccessibilityIdentifier(.settingsDeveloper)
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
        .alert(isPresented: $showAlert) { alertOption() }
        .toasted(show: $presentableToast.show, data: $presentableToast.data)
        .onRotate { _ in
            self.navigationButtonId = UUID()
        }
    }

    // MARK: -

    func alertOption() -> Alert {
        switch activeAlert {
        case .exampleDataConfirmation:
            return Alert(
                title: Text(.settingsExampleDataAlertTitle),
                message: Text(.settingsAreYouSureExampleData),
                primaryButton: .default(
                    Text(.commonYes),
                    action: {
                        do {
                            try dataController.deleteIterateAll()
                            try dataController.createSampleData(appStore: false)
                            self.presentableToast.data
                                = ToastModel(
                                    type: .success,
                                    message: String(.settingsExampleDataCompletedMessage)
                                )
                            self.presentableToast.show = true
                        } catch {
                            errorMessage = error.localizedDescription
                            activeAlert = .exampleDataFailed
                            showAlert.toggle()
                        }
                    }
                ),
                secondaryButton: .cancel()
            )
        case .crashReportTestConfirmation:
            return Alert(
                title: Text(.settingsCrashTestAlertTitle),
                message: Text(.settingsAreYouSureCrashTest),
                primaryButton: .default(
                    Text(.commonYes),
                    action: {
                        Crashes.generateTestCrash()
                    }
                ),
                secondaryButton: .cancel()
            )
        case .restoreDataConfirmation:
            return Alert(
                title: Text(.settingsRestoreAlertTitle),
                message: Text(.settingsRestoreAreYouSure),
                primaryButton: .default(
                    Text(.commonYes),
                    action: {
                        showRestore = true
                    }
                ),
                secondaryButton: .cancel()
            )
        case .backupFailed, .restoreFailed, .exampleDataFailed:
            let title = activeAlert == .backupFailed
                ? Strings.settingsBackupAlertTitle
                : activeAlert == .restoreFailed
                ? Strings.settingsRestoreAlertTitle
                : activeAlert == .exampleDataFailed
                ? Strings.settingsExampleDataAlertTitle
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

struct SettingsDeveloperView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsDeveloperView()
    }
}
