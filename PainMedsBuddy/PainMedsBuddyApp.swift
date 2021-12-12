//
//  PainMedsBuddyApp.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

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
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: save)
        }
    }

    func save(_ note: Notification) {
        dataController.save()
    }
}
