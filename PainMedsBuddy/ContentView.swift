//
//  ContentView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            DosesView(showTakenDoses: false)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Not Taken")
                }
            
            DosesView(showTakenDoses: true)
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
