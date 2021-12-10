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
    
    var meds = [Med]()
    
    init(dataController: DataController) {
        let medsFetchRequest: NSFetchRequest<Med> = Med.fetchRequest()
        medsFetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Med.sequence, ascending: false)
        ]
        
        do {
            self.meds = try dataController.container.viewContext.fetch(medsFetchRequest)
        }
        catch { }
    }
    
    var body: some View {
        TabView(selection: $selectedView) {
            HomeView(dataController: dataController, meds: meds)
                .tag(HomeView.HomeTag)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                 
            DosesView(dataController: dataController, meds: meds, showTakenDoses: true)
                .tag(DosesView.takenTag)
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("History")
                }

            DosesView(dataController: dataController, meds: meds, showTakenDoses: false)
                .tag(DosesView.takenTag)
                .tabItem {
                    Image(systemName: "xmark")
                    Text("Not Taken")
                }
            
            MedsView(meds: meds)
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
        ContentView(dataController: dataController)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
