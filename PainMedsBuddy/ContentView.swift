//
//  ContentView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// INFO: This view is main view in the app.

import SwiftUI
import CoreData

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: String?
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // TODO: This almost certainly needs moving back to the list views below as deletes aren't showing in the meds view, need to investigate
    var meds = [Med]()
    
    init(dataController: DataController) {
        let medsFetchrequest: NSFetchRequest<Med> = Med.fetchRequest()
        medsFetchrequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Med.sequence, ascending: false)
        ]
        
        do {
            self.meds = try dataController.container.viewContext.fetch(medsFetchrequest)
        }
        catch { }
    }
    
    var body: some View {
        TabView(selection: $selectedView) {
            HomeView()
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

            MedsView(meds: meds)
                .tag(MedsView.MedsTag)
                .tabItem {
                    Image(systemName: "pills.fill")
                    Text("Medication")
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
