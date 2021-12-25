//
//  PainMedsBuddyApp.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI
import XNavigation

@main
struct PainMedsBuddyApp: App {
    @StateObject var dataController: DataController

    init() {
        let dataController = DataController()
        // INFO: Assign StateObject
        _dataController = StateObject(wrappedValue: dataController)
    }

    var body: some Scene {
        WindowGroup {
            WindowReader { window in
                ContentView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .environmentObject(dataController)
                    .environmentObject(Navigation(window: window!))
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
                               perform: save)
            }
        }
    }

    func save(_: Notification) {
        dataController.save()
    }
}
