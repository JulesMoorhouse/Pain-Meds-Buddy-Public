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
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
        TabbedSidebar(content: [
            TitledView(
                tag: "0",
                automationId: .tabTitleHome,
                title: String(.tabTitleHome),
                systemImage: SFSymbol.house.systemName,
                view: HomeView(dataController: dataController)),

            TitledView(
                tag: "1",
                automationId: .tabTitleHistory,
                title: String(.tabTitleHistory),
                systemImage: SFSymbol.booksVerticalFill.systemName,
                view: DosesView(dataController: dataController, showElapsedDoses: true)),

            TitledView(
                tag: "2",
                automationId: .tabTitleInProgress,
                title: String(.tabTitleInProgress),
                systemImage: SFSymbol.timer.systemName,
                view: DosesView(dataController: dataController, showElapsedDoses: false)),

            TitledView(
                tag: "3",
                automationId: .tabTitleMedications,
                title: String(.tabTitleMedications),
                systemImage: SFSymbol.pillsFill.systemName,
                view: MedsView(dataController: dataController)),

            TitledView(
                tag: "4",
                automationId: .tabTitleSettings,
                title: String(.tabTitleSettings),
                systemImage: SFSymbol.gearShapeFill.systemName,
                view: SettingsView())
        ])
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
