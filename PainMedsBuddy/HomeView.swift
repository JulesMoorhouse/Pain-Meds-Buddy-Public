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

//    @FetchRequest(entity: Dose.entity(),
//                  sortDescriptors: [NSSortDescriptor(keyPath: \Dose.takenDate, ascending: false)],
//                  predicate: NSPredicate(format: "taken = false")) var doses: FetchedResults<Dose>

    let meds: [Med]
    @State private var doses = [Dose]()

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
            print("Dose count = \(self.doses.count)")
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
                            //ForEach(0 ..< 4) { index in
                                //Text("rem=\(item.doseTimeRemaining) tot=\(item.doseTotalTime)")
                                DoseProgressView(item: DoseProgressItem(
                                    size: size,
                                    count: item.doseTimeRemaining,
                                    total: item.doseTotalTime,
                                    labelMed: item.med?.medTitle ?? "xxx",
                                    labelDose: item.doseDisplay))
                                
//                                DoseProgressView(item: DoseProgressItem(
//                                    size: size,
//                                    count: count,
//                                    total: total,
//                                    labelMed: (index % 2 == 0) ? "Codeine Phosphate" : "Paracetomol",
//                                    labelDose: "1 x 300mg Pill"))
                            }
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding([.horizontal, .top])
                    }

                    HStack {
                        Button("Decrease", action: { self.count -= 1 })
                        Spacer()
                        Button("Increase", action: { self.count += 1 })
                    }

                    VStack(alignment: .leading) {
                        Text("Recently Taken")
                        ForEach(canTakeMeds(), id: \.self) { med in
                            NavigationLink(destination: MedEditView(med: med, add: false)) {
                                MedRowView(med: med)
                            }
                        }
                        Text("Meds Running out")
                        ForEach(lowMeds(), id: \.self) { med in
                            NavigationLink(destination: MedEditView(med: med, add: false)) {
                                MedRowView(med: med)
                            }
                        }
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
