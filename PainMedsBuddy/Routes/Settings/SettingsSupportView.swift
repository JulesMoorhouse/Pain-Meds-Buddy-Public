//
//  SettingsSupportView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import DeviceKit
import SwiftUI
import SwiftUIMailView

struct SettingsSupportView: View {
    @EnvironmentObject private var dataController: DataController
    @State private var mailData: ComposeMailData
    @State private var showMailView = false
    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .copiedEmailAddress

    enum ActiveAlert {
        case copiedEmailAddress
    }

    enum SupportEmail {
        case compose, mailto, paste
    }

    var supportEmailType: SupportEmail {
        if MailView.canSendMail {
            return .compose
        } else if canOpenEmail() {
            return .mailto
        }
        return .paste
    }

    let message: String
    var subject: String { SettingsSupportView.getSubject() }

    var body: some View {
        Button(action: {
            switch supportEmailType {
            case .compose:
                showMailView.toggle()
            case .mailto:
                openSendEmail()
            case .paste:
                UIPasteboard.general.string
                    = Secrets.supportEmail
                self.activeAlert = .copiedEmailAddress
                self.showAlert = true
            }
        }, label: {
            HStack {
                Text(.settingSupportButton)
            }
            .accessibilityElement()
            .accessibility(addTraits: .isButton)
            .accessibilityIdentifier(.settingSupportButton)
        })
        .frame(maxWidth: .infinity, alignment: .center)
        .alert(isPresented: $showAlert) { alertOption() }
        .sheet(isPresented: $showMailView) {
            MailView(data: $mailData) { result in
                print(result)
            }
        }
    }

    static func getSubject() -> String {
        let appInitials = String(.commonAppNameInitials)
        let version = "\(Bundle.main.shortVersion) (\(Bundle.main.buildNumber))"

        return InterpolatedStrings.settingSupportSubject(
            appInitials: appInitials,
            version: version
        )
    }

    static func getMessage(totalMeds: Int,
                           totalDoses: Int,
                           installDate: String,
                           runCount: Int) -> String
    {
        let appName = String(.commonAppName)
        let code: String = Locale.preferredLanguages[0]
        let language: String = NSLocale.current.localizedString(forLanguageCode: code)!
        let iOSVersion: String = Device.current.systemVersion ?? ""

        return InterpolatedStrings.settingSupportMessage(values: [
            appName,
            Device.current.description,
            iOSVersion,
            "\(language) (\(code))",
            "\(totalMeds)",
            "\(totalDoses)",
            installDate,
            "\(runCount)",
            "\(Bundle.main.buildDate)",
        ])
    }

    func mailToString() -> String {
        "mailto:\(Secrets.supportEmail)?subject=\(subject)&body=\(message)"
            .addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed)!
    }

    func canOpenEmail() -> Bool {
        let mailtoUrl = URL(string: mailToString())!
        return UIApplication.shared.canOpenURL(mailtoUrl)
    }

    func openSendEmail() {
        let mailtoUrl = URL(string: mailToString())!

        if UIApplication.shared.canOpenURL(mailtoUrl) {
            UIApplication.shared.open(mailtoUrl, options: [:])
        }
    }

    func alertOption() -> Alert {
        switch activeAlert {
        case .copiedEmailAddress:
            return Alert(
                title: Text(.commonInfo),
                message: Text(.settingSupportCopied),
                dismissButton: .default(
                    Text(.commonOK))
            )
        }
    }

    init(dataController: DataController) {
        let totalMeds = dataController.count(for: Med.fetchRequest())
        let totalDoses = dataController.count(for: Dose.fetchRequest())

        let defaults = UserDefaults.standard
        let runCount = defaults.integer(forKey: "runCount")
        let installDate: String = defaults.string(forKey: "installDate") ?? ""

        message = SettingsSupportView.getMessage(
            totalMeds: totalMeds,
            totalDoses: totalDoses,
            installDate: installDate,
            runCount: runCount
        )

        _mailData = State(wrappedValue: ComposeMailData(
            subject: SettingsSupportView.getSubject(),
            recipients: [Secrets.supportEmail],
            message: message,
            attachments: []
        )
//            attachments: [AttachmentData(
//                data: "Some text".data(using: .utf8)!,
//                mimeType: "text/plain",
//                fileName: "text.txt")])
        )
    }
}

struct SettingsSupportView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSupportView(dataController: DataController.preview)
    }
}
