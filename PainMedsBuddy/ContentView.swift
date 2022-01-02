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
                    Image(systemName: SFSymbol.house.systemName)
                    Text(.tabTitleHome)
                        .accessibilityIdentifier(.tabTitleHome)
                }

            DosesView(dataController: dataController, showElapsedDoses: true)
                .tag(DosesView.historyTag)
                .tabItem {
                    Image(systemName: SFSymbol.checkmark.systemName)
                    Text(.tabTitleHistory)
                        .accessibilityIdentifier(.tabTitleHistory)
                }

            DosesView(dataController: dataController, showElapsedDoses: false)
                .tag(DosesView.inProgressTag)
                .tabItem {
                    Image(systemName: SFSymbol.arrowTriangle2CirclePath.systemName)
                    Text(.tabTitleInProgress)
                        .accessibilityIdentifier(.tabTitleInProgress)
                }

            MedsView()
                .tag(MedsView.MedsTag)
                .tabItem {
                    Image(systemName: SFSymbol.pillsFill.systemName)
                    Text(.tabTitleMedications)
                        .accessibilityIdentifier(.tabTitleMedications)
                }

            SettingsView()
                .tag(SettingsView.SettingsTag)
                .tabItem {
                    Image(systemName: SFSymbol.gearShapeFill.systemName)
                    Text(.tabTitleSettings)
                        .accessibilityIdentifier(.tabTitleSettings)
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
