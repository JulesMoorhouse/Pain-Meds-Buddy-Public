//
//  ContentView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// INFO: This view is main view in the app.

import AckGenUI
import SwiftUI
import CoreData

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: String?
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        TabView(selection: $selectedView) {
            HomeView(dataController: dataController)
                .tag(HomeView.HomeTag)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                 
            DosesView(dataController: dataController, showElapsedDoses: true)
                .tag(DosesView.historyTag)
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("History")
                }

            DosesView(dataController: dataController, showElapsedDoses: false)
                .tag(DosesView.inProgressTag)
                .tabItem {
                    Image(systemName: "arrow.triangle.2.circlepath")
                    Text("In Progress")
                }
            
            MedsView()
                .tag(MedsView.MedsTag)
                .tabItem {
                    Image(systemName: "pills.fill")
                    Text("Medication")
                }
            
            SettingsView()
                .tag(SettingsView.SettingsTag)
                .tabItem {
                    Image(systemName: "gearshape.fill")
                        Text("Settings")
                }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
