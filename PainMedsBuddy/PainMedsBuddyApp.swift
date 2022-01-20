//
//  PainMedsBuddyApp.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import AppCenterCrashes
import SwiftUI
import XNavigation

@main
struct PainMedsBuddyApp: App {
    @StateObject var dataController: DataController
    @StateObject var presentableToast: PresentableToast
    @State var colourScheme: ColorScheme?

    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)

        let presentableToast = PresentableToast()
        _presentableToast = StateObject(wrappedValue: presentableToast)

        AppCenter.start(
            withAppSecret: Secrets.appCenterSecret,
            services: [Crashes.self])

        dataController.processDoses()

        #if targetEnvironment(simulator)
            // Disable hardware keyboards.
            let setHardwareLayout = NSSelectorFromString("setHardwareLayout:")
            UITextInputMode.activeInputModes
                // Filter `UIKeyboardInputMode`s.
                .filter { $0.responds(to: setHardwareLayout) }
                .forEach { $0.perform(setHardwareLayout, with: nil) }
        #endif
    }

    var body: some Scene {
        WindowGroup {
            WindowReader { window in
                ContentView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .environmentObject(dataController)
                    .environmentObject(presentableToast)
                    .environmentObject(Navigation(window: window!))
                    // INFO: Automatically save when we detect that we are no longer
                    // the foreground app, Use this rather than the scene phase
                    // API so we can port to macOS, where scene phase won't detect
                    // out app losing focus as of macOS 11.1.
                    .onReceive(
                        NotificationCenter.default.publisher(
                            for: UIApplication.willResignActiveNotification),
                        perform: save)
                    .onReceive(NotificationCenter.default.publisher(
                        for: UIApplication.didBecomeActiveNotification),
                    perform: processDoses)
                // .preferredColorScheme(colourScheme)
            }
        }
    }

    func processDoses(_: Notification) {
        dataController.processDoses()
    }

    func save(_: Notification) {
        dataController.save()
    }
}
