//
//  HomeView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// INFO: This view shows a summary on medication which has or can be taken next

import CircularProgress
import CoreData
import SwiftUI

struct HomeView: View {
    static let HomeTag: String? = "Home"

    @EnvironmentObject var dataController: DataController

    let meds: [Med]
    var doses = [Dose]()

    let listRows = 3

    @State var count = 0
    let size: CGFloat = 150
    let total = 10

    var columns: [GridItem] {
        [GridItem(.fixed(200))]
    }

    init(dataController: DataController, meds: [Med]) {
        self.meds = meds.allMedsDefaultSorted

        let dosesFetchRequest: NSFetchRequest<Dose> = Dose.fetchRequest()
        dosesFetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Dose.takenDate, ascending: false)
        ]
        dosesFetchRequest.predicate = NSPredicate(format: "elapsed = false")
        do {
            self.doses = try dataController.container.viewContext.fetch(dosesFetchRequest)
            print("Dose count = \(doses.count)")
        } catch {
            print("Error getting data for doses \(error.localizedDescription)")
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: columns) {
                            ForEach(doses, id: \.self) { item in

                                DoseProgressView(item: DoseProgressItem(
                                    size: size,
                                    elapsed: item.doseElapsedInt,
                                    remaining: item.doseTimeRemainingInt,
                                    total: item.doseTotalTime,
                                    labelMed: item.med?.medTitle ?? MedDefault.title,
                                    labelDose: item.doseDisplay))
                            }
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding([.horizontal, .top])
                    }

                    VStack(alignment: .leading) {
                        Text("Recently Taken")
                        ForEach(canTakeMeds(), id: \.self) { med in
                            NavigationLink(destination: MedEditView(med: med, add: false)) {
                                HomeMedRow(med: med)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .background(Color.secondarySystemGroupedBackground)
                        .cornerRadius(5)
                        .shadow(color: Color.black.opacity(0.2), radius: 5)

                        Text("Meds Running out")
                        ForEach(lowMeds(), id: \.self) { med in
                            NavigationLink(destination: MedEditView(med: med, add: false)) {
                                MedRowView(med: med)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .background(Color.secondarySystemGroupedBackground)
                        .cornerRadius(5)
                        .shadow(color: Color.black.opacity(0.2), radius: 5)
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
        }
    }

    func uniqueDoseMeds() -> [Med] {
        let uniqeDoseMeds = Array(Set(doses.filter { $0.med != nil }.compactMap { $0.med }))
        return uniqeDoseMeds
    }

    func canTakeMeds() -> [Med] {
        // Get unique meds which are currently not elapsed
        var temp = meds.filter { !uniqueDoseMeds().contains($0) }
        temp = temp.sortedItems(using: .lastTaken)
        return temp.prefix(listRows).map { $0 }
    }

    func lowMeds() -> [Med] {
        let temp = meds.sortedItems(using: .remaining)
        return temp.prefix(listRows).map { $0 }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        HomeView(dataController: dataController, meds: [Med()])
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
