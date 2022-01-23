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
import Introspect

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: String?
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    @StateObject var tabBarHandler: TabBarHandler

    var body: some View {
        NavigationViewParent {
            TabView(selection: $selectedView) {
                HomeView(dataController: dataController)
                    .tag(HomeView.homeTag)
                    .tabItem {
                        Image(systemName: HomeView.homeIcon)
                        Text(.tabTitleHome)
                    }

                DosesView(dataController: dataController, showElapsedDoses: true)
                    .tag(DosesView.historyTag)
                    .tabItem {
                        Image(systemName: DosesView.historyIcon)
                        Text(.tabTitleHistory)
                    }

                DosesView(dataController: dataController, showElapsedDoses: false)
                    .tag(DosesView.inProgressTag)
                    .tabItem {
                        Image(systemName: DosesView.inProgressIcon)
                        Text(.tabTitleInProgress)
                    }

                MedsView(dataController: dataController)
                    .tag(MedsView.medsTag)
                    .tabItem {
                        Image(systemName: MedsView.medsIcon)
                        Text(.tabTitleMedications)
                    }

                SettingsView()
                    .tag(SettingsView.settingsTag)
                    .tabItem {
                        Image(systemName: SettingsView.settingsIcon)
                        Text(.tabTitleSettings)
                    }
            }.background(Color.green)
                .introspectTabBarController { tabBarController in
                    self.tabBarHandler.tabBarController = tabBarController
                }
        }.background(Color.yellow)
            .environmentObject(tabBarHandler)
    }

    init() {
        let tabBarHandler = TabBarHandler()
        _tabBarHandler = StateObject(wrappedValue: tabBarHandler)
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
