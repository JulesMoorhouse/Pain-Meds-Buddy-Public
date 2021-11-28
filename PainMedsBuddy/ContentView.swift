//
//  ContentView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: String?
    
    var body: some View {
        TabView(selection: $selectedView) {
            HomeView()
                .tag(HomeView.tag)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            DosesView(showTakenDoses: false)
                .tag(DosesView.notTakenTag)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Not Taken")
                }
            
            DosesView(showTakenDoses: true)
                .tag(DosesView.takenTag)
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("Taken")
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
