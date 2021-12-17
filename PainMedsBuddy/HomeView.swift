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

    @FetchRequest(entity: Med.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Med.sequence, ascending: true)],
                  predicate: nil) var meds: FetchedResults<Med>

    var doses = [Dose]()

    let listRows = 3

    var columns: [GridItem] {
        [GridItem(.fixed(200))]
    }

    var noData: Bool {
        doses.count == 0 && canTakeMeds().count == 0 && lowMeds().count == 0
    }

    var items: [Med] {
        DataController.resultsToArray(meds).allMeds
    }

    init(dataController: DataController) {
        let dosesFetchRequest = NSFetchRequest<Dose>(entityName: "Dose")
        dosesFetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Dose.takenDate, ascending: false)
        ]
        dosesFetchRequest.predicate = NSPredicate(format: "elapsed = false")
        do {
            self.doses = try dataController.container.viewContext.fetch(dosesFetchRequest)
        } catch {
            print("Error getting data for doses \(error.localizedDescription)")
        }
    }

    var body: some View {
        NavigationView {
            Group {
                if noData {
                    PlaceholderView(text: "There's nothing here right now!",
                                    imageString: "pills")
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            if doses.count > 0 {
                                Text("Current meds")
                                    .foregroundColor(.secondary)
                                    .padding(.leading)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHGrid(rows: columns) {
                                        ForEach(doses, id: \.self) { item in

                                            if let med = item.med {
                                                DoseProgressView(dose: item, med: med, size: 150)
                                            }
                                        }
                                    }
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding([.horizontal, .bottom])
                                }
                            }

                            VStack(alignment: .leading) {
                                if canTakeMeds().count > 0 {
                                    VStack(alignment: .leading) {
                                        Text("Recently taken")
                                            .foregroundColor(.secondary)

                                        ForEach(canTakeMeds(), id: \.self) { med in
                                            HomeMedRow(med: med)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(2)
                                        }
                                        .panelled()
                                    }
                                    .padding(.bottom)
                                }

                                if lowMeds().count > 0 {
                                    VStack(alignment: .leading) {
                                        Text("Meds running out")
                                            .foregroundColor(.secondary)

                                        ForEach(lowMeds(), id: \.self) { med in
                                            NavigationLink(destination: MedEditView(med: med, add: false)) {
                                                HStack {
                                                    MedRowView(med: med)
                                                        .frame(maxWidth: .infinity, alignment: .leading)

                                                    Image(systemName: "chevron.right")
                                                        .font(.body)

                                                    Spacer()
                                                        .frame(width: 10)
                                                }
                                                .padding(2)
                                            }
                                        }
                                        .panelled()
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .background(!noData ? Color.systemGroupedBackground.ignoresSafeArea() : nil)
            .navigationTitle("Home")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func uniqueDoseMeds() -> [Med] {
        let uniqeDoseMeds = Array(Set(doses.filter { $0.med != nil }.compactMap { $0.med }))
        return uniqeDoseMeds
    }

    func canTakeMeds() -> [Med] {
        // Get unique meds which are currently not elapsed
        var temp = items.filter { !uniqueDoseMeds().contains($0) }
        temp = temp.sortedItems(using: .lastTaken)
        return temp.prefix(listRows).map { $0 }
    }

    func lowMeds() -> [Med] {
        let temp = items.sortedItems(using: .remaining)
        return temp.prefix(listRows).map { $0 }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        HomeView(dataController: dataController)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
