//
//  ContentView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// INFO: This view is main view in the app.

import AckGenUI
import CoreData
import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: String?
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
        TabView(selection: $selectedView) {
            HomeView()
                .tag(HomeView.HomeTag)
                .tabItem {
                    Image(systemName: "house")
                    Text(.tabTitleHome)
                }

            DosesView(dataController: dataController, showElapsedDoses: true)
                .tag(DosesView.historyTag)
                .tabItem {
                    Image(systemName: "checkmark")
                    Text(.tabTitleHistory)
                }

            DosesView(dataController: dataController, showElapsedDoses: false)
                .tag(DosesView.inProgressTag)
                .tabItem {
                    Image(systemName: "arrow.triangle.2.circlepath")
                    Text(.tabTitleInProgress)
                }

            MedsView()
                .tag(MedsView.MedsTag)
                .tabItem {
                    Image(systemName: "pills.fill")
                    Text(.tabTitleMedication)
                }

            SettingsView()
                .tag(SettingsView.SettingsTag)
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text(.tabTitleSettings)
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
