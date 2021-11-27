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
        // Assign StateObject
        _dataController = StateObject(wrappedValue: dataController)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
