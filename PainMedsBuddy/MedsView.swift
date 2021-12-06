//
//  MedicationsView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// This view shows all the available medication

import SwiftUI

struct MedsView: View {
    static let MedsTag: String? = "Medications"
    
    let meds: [Med]
    
    @State private var showingSortOrder = false
    @State private var sortOrder = Med.SortOrder.optimzed
    
    init(meds: [Med]) {
        self.meds = meds.allMedsDefaultSorted
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(items(), id: \.self) { med in
                        MedRowView(med: med)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .disabled($showingSortOrder.wrappedValue == true)
        
                if $showingSortOrder.wrappedValue == true {
                    popUpView()
                }
            }
            .navigationTitle("Medications")
            .toolbar {
                Button(action: {
                    self.showingSortOrder = true
                }) {
                    Label("Sort", systemImage: "arrow.up.arrow.down")
                }
            }
        }
    }
    
    func items() -> [Med] {
        switch sortOrder {
        case .title:
            return meds.allMeds.sorted { $0.medDefaultTitle < $1.medDefaultTitle }
        case .creationDate:
            return meds.allMeds.sorted { $0.medCreationDate < $1.medCreationDate }
        default:
            return meds.allMedsDefaultSorted
        }
        
    }
    
    func popUpButton(_ text: String) -> some View {
        Text(text)
            .padding(10)
            .frame(width: 150)
            .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                    )
    }
    
    func popUpView() -> some View {
        VStack(spacing: 10) {
            Text("Sort Order")
                .bold()
            
            Spacer()
            
            Button(action: {
                sortOrder = .optimzed
                showingSortOrder = false
            }) {
                popUpButton("Optimized")
            }
            Button(action: {
                sortOrder = .creationDate
                showingSortOrder = false
            }) {
                popUpButton("Created Date")
            }
            Button(action: {
                sortOrder = .title
                showingSortOrder = false
            }) {
                popUpButton("Title")
            }
        }
        .padding()
        .frame(width: 240, height: 220)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}

struct MedicationsView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        MedsView(meds: [Med()])
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
